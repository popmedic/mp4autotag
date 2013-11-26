require 'digest/md5'

require './lib/search_movie.rb'
require './lib/search_show.rb'
require './lib/search_itunes.rb'
require './lib/tag.rb'

$MOVIE_REGXS = [
  /((?:.*))(?:\(|\W)([0-9]{4})(?:\)){0,1}/
]
$SHOW_REGXS = [
  /((?:.*))(?:\/|\W+)(?:season|Series|sea|s)\W?((?:\d{1,4}))(?:\/|\W|x){0,1}(?:(?:episode|epi|ep|e)\W?)*(\d+)/i,
  /((?:.*))(?:\/|\W+)((?:\d{1,2}))\W*x\W*(\d+)/i,
  /((?:.*))(?:\/|\W+)()(?:e)(\d+)/i
];

class Search
  def Search::search(search_path, use_itunes=0)
    rtn = []
    results = []
    
    s = search_path.gsub(/[\.\-\_]/, ' ')
    ext = File.extname(search_path)
    md = /(\.mp4)|(\.m4v)|(\.mov)|(\.mkv)|(\.ogg)|(\.avi)|(\.flv)|(\.m1v)|(\.m2v)|(\.mpeg)|(\.roq)|(\.rm)|(\.swf)|(\.wmv)/.match(ext)
    if(md != nil) 
      s = s.chomp(ext[1,3])
    end
    
    dbug "Search on: " << s
    $MOVIE_REGXS.each do |regx|
      md = regx.match(s)
      if(md)
        y = md[2].to_i
        if(y > 1880 && y <= Time.now.year.to_i)
          dbug "Movie Matched: " << search_path 
          dbug "\tMovie: " << File.basename(md[1]) << ";\tYear: " << md[2]
          results << Hash["Type" => "Movie", "Movie" => File.basename(md[1]), "Year" => md[2]]
          break
        end
      else
        #dbug "Movie NOT Matched: " << fn
      end
    end
    $SHOW_REGXS.each do |regx|
      md = regx.match(s)
      if(md)
        dbug "Show Matched: " << search_path 
        dbug "\t Series: " << File.basename(md[1]) << ";\tSeason: " << md[2] << ";\tEpisode: " << md[3]
        results << Hash["Type" => "Show", "Series" => File.basename(md[1]), "Season" => md[2], "Episode" => md[3]]
        break
      else
        #dbug "Show NOT Matched: " << fn
      end
    end
    if(results.empty?)
      dbug "UNABLE TO MATCH: " << s
      dbug "Do movie search."
      rtn.concat(Search.movie_search(s, File.basename(s), "0"))
    else
      results.each do |res|
        if(res["Type"] == "Movie")
          rtn.concat(Search.movie_search(s, res["Movie"], res['Year']))
        elsif(res['Type'] == "Show")
          rtn.concat(Search.show_search(s, res['Series'], res['Season'], res["Episode"]))
        end
      end
    end
    #now if it is a use_itunes request, 
    if(use_itunes == 1)
      #get the images from itunes
      rtn.each do |tag|
        if(tag["Media Type"]["value"] == 'tvshow')
          img_path = SearchITunes.get_image({"serstr" => tag["TV Show"]['value'], "seastr" => tag['TV Season']['value']}, false)
        else
          img_path = SearchITunes.get_image({"movstr" => tag["TV Show"]['value'], "yearstr" => tag['Release Date']['value'].to_i().to_s()}, true)
        end
        #self.dbug(img_path)
        if(img_path!=nil)
          if(img_path != "")
            tag["Image Path"] = img_path
          end
        end
      end
    end
    return rtn
  end
  
  def Search::movie_search(basestr, movstr, yearstr)
    Search.dbug "MOVIE SEARCH: basestr = \"%s\", movstr = \"%s\", yearstr = \"%s\"" % 
                          [basestr, movstr, yearstr]
    return SearchMovie.search({'basestr' => basestr, 'movstr' => movstr, 'yearstr' => yearstr})
  end
  
  def Search::show_search(basestr, serstr, seastr, epistr)
    Search.dbug "SHOW SEARCH: basestr = \"%s\", serstr = \"%s\", seastr.to_i = \"%i\", epistr.to_i = \"%i\"" % 
                          [basestr, serstr, seastr.to_i, epistr.to_i]
    return SearchShow.search({'basestr' => basestr, 'serstr' => serstr, 'seastr' => seastr, 'epistr' => epistr})
  end
  
  def Search::to_html(res)
    html = "<html><head><title>mp4autotag_server</title></head><body><table>"
    if(res.count > 0)
      row = res[0]
      #keys = row.keys
      keys = ["Name","Image Path","Series Image Path","TV Show","TV Season","TV Episode",
              "Category","Media Type","Genre","Artist","Composer","Release Date","Album",
              "Track","Grouping","Comments","Album Artist","Copyright","TV Network",
              "TV Episode Number","Short Description","cnID","dbid"]
      html << "<thead><tr>"
      keys.each do |key|
        html << "<th>" << key << "</th>"
      end
      html << "</tr></thead><tbody>"
      res.each do |tag|
        html << "<tr>"
        keys.each do |key|
          if(key.casecmp("Image Path") == 0 || key.casecmp("Series Image Path") == 0)
            val = tag[key]
            if(val != nil)
              html << "<td><img src=\"" << val << "\" height=\"120px\" /></td>"
            else
              html << "<td></td>"
            end
          elsif(key.casecmp("dbid") == 0)
            html << "<td>" << tag[key] << "</td>"
          else
            if(tag[key].is_a? Hash)
              val = tag[key]['value']
              if(val != nil)
                html << "<td>" << val.to_s << "</td>"
              else
                html << "<td></td>"
              end
            end
          end
        end
        html << "</tr>"
      end
    end
    html << "</tbody></table></body></html>"
    return html
  end
  
  def Search::query(urlstr)
    str = ''
    cfn = "./cache/" << Digest::MD5.hexdigest(urlstr)
    
    if(File.exists?(cfn))
      dbug "CACHE FILE EXISTS: %s" % cfn
      cf = File.open(cfn, "rb")
      str << cf.read
      cf.close
      dbug "CACHE READ: %s" % cfn
    else
      dbug "CACHE FILE DOESN'T EXISTS: %s" % cfn
      open(urlstr) do |f|
        str << f.read
      end
      if str == ''
        return nil
      else
        cf = File.open(cfn, "wb")
        cf.write(str)
        cf.close
        dbug "CACHE WRITE: %s" % cfn
      end
    end
    return str
  end
  
  def Search::dbug(str)
    if $DEBUG_POP
      puts "[%s] DEBUG  %s. (search.rb)" % [Time.now.to_s.sub(/ [\-\+][0-9]{4}$/, ''), str]
    end
  end
end
