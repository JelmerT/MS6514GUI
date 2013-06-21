MS6514GUI
=========

A Processing GUI for the [MS6514](http://www.p-mastech.com/index.php?page=shop.product_details&flypage=flypage.tpl&product_id=150&category_id=18&option=com_virtuemart&Itemid=29) digital thermometer from Mastech. It's a relatively [cheap](http://www.goodluckbuy.com/mastech-ms6514-dual-channel-digital-thermometer.html) 2 channel hand held digital thermometer with a usb interface. 
It might work for some other meters from Mastech too with possible small changes to the serial interpreter.

This is a quick and dirty implementation of a simple GUI. The meter has a serial over USB connection that periodicaly spits out all the info.
The interface has all the info available on the LCD on the meter itself and all the buttons.
Temperature measurements are logged in a graph and can be saved to a file.

I had to reverse engineer the serial protocol, so there might still be bugs present.

Software provided as is. Contact me for more info.

license
-------
Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)
