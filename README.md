# qIdentification
An identification card resource created for use with linden_inventory for ESX Legacy.
This resource was inspired by the original jsfour identification script and still uses some of the javascript from it. The rest of the LUA is entirely re-written.

![ID Card Preview](https://i.imgur.com/PxVi8jK.png)

# Dependencies
## Hard Dependencies
These are required resources that this resource was built around. It's not designed to work without these resources and if you want to remove the requirement for them you'll be better off writing your own resource rather than try to remove those dependencies from this resource. 
* [ESX Legacy](https://github.com/esx-framework/es_extended)
* [linden_inventory](https://github.com/thelindat/linden_inventory)
* [screenshot-basic](https://github.com/jonassvensson4/screenshot-basic)
* [mugshot](https://github.com/jonassvensson4/mugshot)
## Soft Dependencies
By default this resource needs these resources, however the core functionality (creating identification cards, metadata, showing identification cards) will still work if you remove the appropriate code in peds.lua and menu.lua
* [qtarget](https://github.com/QuantusRP/qtarget)
* [nh-context](https://github.com/nerohiro/nh-context)
* [nh-keyboard](https://github.com/nerohiro/nh-keyboard)

# Installation
1. Drag and drop into your resource folder
2. Make sure you install the required dependencies (listed above)
3. Follow the instructions to install the other resources - especially the mugshot one for the imgur API
4. Done!


# Config / Disclaimer
## Cards Types 
I've done my best to provide a configurable resource. You are able to add your own identification types to this list however it's not just just plug and play, you'll still need to modify the server event and the js events for additional 

You'll have to make sure that the list reflects the items that are available for you and your server, along with your own costs.

## The rest of the config is pretty heavily commented, so it should be self explanatory. 