[Learn how to go from DVD to iTunes and AppleTV with all the info!](http://www.popmedic.com/backupdvdOSX.html)

# Mp4Autotag #

[Download](https://github.com/popmedic/mp4autotag/wiki/download)

![icon.](http://www.popmedic.com/images/mp4autotag_icon_32.png) 

### Table of Contents ###
1. [Introduction](#introduction)
2. [Download Mp4Autotag](#download-mp4autotag) 
3. [Installing](#installing)
4. [Overview](#overview)
5. [The Main Window](#the-main-window) 
6. [The Autotag Panel](#the-autotag-panel) 
7. [The Automated Autotag Panel](#the-automated-autotag-panel)
8. [Preferences](#preferences)
9. [Cover Art Tab](#cover-art-tab)
10. [Other Tab](#other-tab)
11. [Dev Team](#dev-team)

## Introduction ##
Mp4AutoTag is a meta data editor for mp4 file types.  In-other-words, it edits the info you see about the mp4 file in iTunes and Finder.  Mp4AutoTag atempts to locate your mp4 file by file name in [thetvdb.com](http://thetvdb.com) or [themoviedb.org](http://www.themoviedb.org).  It then allows you to save the information to the file.  You can also edit the results, attach different images, rename the file automatically to the proper standard, and/or add a watermark to the image. Images can be pulled from not only [thetvdb.com](http://thetvdb.com) or [themoviedb.org](http://www.themoviedb.org), but also [iTunes Store](http://www.apple.com/itunes/).

[Table of Contents](#table-of-contents)

## Download Mp4Autotag ##

You can download the latest Mp4Autotag and older versions from the [download page](https://github.com/popmedic/mp4autotag/wiki/download).

[Table of Contents](#table-of-contents)

## Installing ##

Install by unzipping the downloaded file and copy the Mp4Autotag(.app) file to the Applications directory.

Run Mp4Autotag by browsing to Applications and clicking on Mp4Autotag.

[Table of Contents](#table-of-contents)

## Overview ##

### The Main Window ###

![mp4autotag application empty queue.](http://www.popmedic.com/images/mp4autotag_empty.0.1.3.png)

When you start Mp4Autotag you will see the above Window.  You can drag and drop files into this Window to add mp4's or you can click on the "Add" button, or "File | Add..." to add mp4's to the queue.
![mp4autotag application with Kanon Series in queue.](http://www.popmedic.com/images/mp4autotag_full.0.1.3.png)
Once you have mp4's in the queue, you can select them and edit their current tags in the lower panel.  Once edited, you can save the changes by clicking on the "Save" button, or "File | Save".  You could also "Autotag" the mp4 by clicking on the "Autotag" button. If you want to "Autotag" all your mp4's then select all the files in the queue and click the "Autotag" button.  You can also do an "Automated" autotagging of files by selecting the files you want "Automated" autotagging done to and clicking the "Automated" button.  The "Preferences" button will bring up the [preferences](#preferences) panel where you can customize how Mp4Autotag behaves.
* **Removing**
	 will remove the selected file(s) from the queue.
	1. Select file(s) to remove.
	2. Click Remove button.
* **Saving**
	 will save the selected file(s) edited tag data.
	1. Select file(s) to save.
	2. Click Save button.
* **Autotagging**
	 will bring up a search results window for all files selected.  
	It will take a file name, use its full path to decide if the files is a 
	Show or a Movie, then based on that pattern match, search the appropriate 
	databases for information about that show/movie.The search results window will 
	present the user with a list of tags to attach to the file.
	1. Select file(s) to Autotag.
	2. Click Save button.
* **Automated**
	 will do a batch autotagging of the selected file(s).  Each file selected
	will be searched and the top result will be used to tag the current file.  After the process
	the user is presented a results window where they can see what has been changed, and undo the 
	changes if they are not correct.
	1. Select file(s) to Automated.
	2. Click Automated button.

[Table of Contents](#table-of-contents)

### The Autotag Panel ###

![mp4autotag autotag panel.](http://www.popmedic.com/images/mp4autotag_autotagwnd.0.1.3.png)

The Autotag Panel will appear when you do a "Autotag" or "Autotag All".  This panel provides you with a table to see the results for the search on the mp4 file shown in the bottom status line.  Select the result that looks most correct to you and click on the tag button to merge and save the meta-data content to the mp4 file.  If the result you want is not in the table, then try a "Custom Search" by clicking on the "Search" button.  The "Close" button will close the "Autotag" or "Autotag All" session. 

[Table of Contents](#table-of-contents)

### The Automated Autotag Panel ###

If you hit the "Automated" button, all the files in the queue will be searched and tagged with the first result returned.  

![mp4autotag autotag automated running panel, other.](http://www.popmedic.com/images/mp4autotag_automatedwnd_running.0.1.3.png)

Once complete, the below panel will be present so you can undo any changes the automated autotag made that are not correct.

![mp4autotag autotag automatedpreferences panel, other.](http://www.popmedic.com/images/mp4autotag_automatedwnd.0.1.3.png) 

* **Left Panel** - This is a table that has the results of the "Fully Automated Autotag."  Select rows in this table to see the changed properties.  If you do not like the changes, click the "Undo" button in the "Right Panel."
* **Right Panel** - This is a table showing the changes in the selected file of the "Left Panel."  Properties changed will be highlighted in red.  If you don't like the changes, click the "Undo" button. 
* **Undo Button** - This button will "Undo" the changes made to the file selected in the "Left Panel."

[Table of Contents](#table-of-contents)

### Preferences ###

#### Cover Art Tab ####

![mp4autotag preferences panel, Cover Art.](http://www.popmedic.com/images/mp4autotag_preferences_ca.0.1.3.png)

* **Use unique TVDB art for each episode.** - When selected show searches will return the image path to an unique image for the episode from [thetvdb.com](http://www.thetvdb.com).
* **Use series art for each episode.** - When selected show searches will return the image path to an image for the series.
* **Add watermark for season/episode.** - When selected image will be watermarked with "S00E00".
* **Use high quality iTunes art.** - When selected the search will return image path to an image from iTunes store. 

[Table of Contents](#table-of-contents)

#### Other Tab ####

![mp4autotag preferences panel, other.](http://www.popmedic.com/images/mp4autotag_preferences_other.0.1.3.png) 

* **Rename file to standard convention.** - This option will rename the mp4 file to a standard convention (for movies - "movie name" ("year"), for shows - "show name" - S"season number"E"episode number" - "episode title").
* **Optimize for network.** - This option will use the mp4v2 2.0.0 function MP3Optimize on the file.  _This option could add up to a minute of processing on saves_.
* **Use "Popmedic" proxy search.** - This option will use a proxy search though [popmedic.com](http://www.popmedic.com/cgi/mp4autotag_cgi.rb).  By using this proxy you will have the most comprehensive and up-to-date search I provide.  You can turn this option off, but the results of a search will not be as accurate.  _See more about the proxy in the Design notes below._ 

[Table of Contents](#table-of-contents)

## Dev Team ##

* Master Coder - popmedic  
* Sidekick - muttsnutts

[Table of Contents](#table-of-contents)
