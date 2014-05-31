nexmo
=====


A Ruby wrapper for the [Nexmo API](https://www.nexmo.com/documentation/api/index.html).


Installation
------------

    $ gem install nexmo-tts


Quick start (making a call reques)
-------------------------------

First you need to load up the gem and construct a NexmoTts::Client object
with your API credentials, like this:

```ruby
require 'nexmo'

nexmo = NexmoTts::Client.new('...API KEY...', '...API SECRET...')
```

To initiate a call use the call method. The default response method selected is JSON, to select XML by pass required params while calling the method. The default mode is the tts. To choose tts-prompt pass the required params.

```ruby
nexmo.call(:text=> "Hello World!", :to => xxxxxxx, :mode=>"tts", :response_method => "json")
```

The reponse provided will be converted into a JSON object if the params passed is JSON otherwise it will just return the response body.
If Nexmo returns a error message then calling the method will give the error text.


Troubleshooting
---------------

Remember that phone numbers should be specified in international format.

Please report all bugs/issues via the GitHub issue tracker.
