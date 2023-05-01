# GisMeteoServise
This is a bit of an old project, it probably needs refactoring and, for example, test coverage, as time permits. However, it does work.


### It's a small rack service for weather
It bypassess on the gismeteo.ru the weather location pages specified in the setting and parses html and returns xml, caching the results.  
You can set the refresh rate and use a proxy.

| path| page|
|--|--|
| `/weather/petersburg`| specific location|
| `/weather`| list of available locations with links|
| `/`| placeholder Olusha|

```xml
<?xml version="1.0" encoding="UTF-8"?>
<weather>
	<updated_at>2023-04-26 20:02:22 +03:00</updated_at>
	<location>Калининград</location>
	<url>https://www.gismeteo.ru/weather-kaliningrad-4225/now/</url>
	<temperature>+8</temperature>
	<feel>+5</feel>
	<cloudiness>Пасмурно, без осадков</cloudiness>
	<wind>7 м/c западный</wind>
	<pressure>757</pressure>
	<humidity>63</humidity>
	<sunset>20:02 Заход</sunset>
	<sunrise>5:11 Восход</sunrise>
</weather>

```

Since its a rack app, you can run it with any compatible web server, such as puma.  
By default, the app will run using Webrick on port 3100.

You can read more about the configuration in the file `config.ru`

### systemd service
The repository also contains the systemd config for Ubuntu to run from the user.  
To run an app as a systemd service, you must:
* copy `docs/gismeteo.service.sample` to `/home/[USER]/.config/systemd/user/gismeteo.service`
* edit the config according to the tips in the file header
* run: `loginctl enable-linger [USER]`
  > It's necessary that the service doesn't stop after leaving the shell.  
  > Replace [USER] with your system user.
* run:
    ``` bash
    # enable service
    systemctl --user reenable gismeteo
    # start service
    systemctl --user start gismeteo
    ```
More details in the file `gismeteo.service.sample`  

GL HF
