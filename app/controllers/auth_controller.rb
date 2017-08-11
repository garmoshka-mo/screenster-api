require 'logger'

class AuthController < ActionController::Base
  protect_from_forgery with: :exception

  def login
    agent = Mechanize.new
    agent.log = Logger.new(STDERR)
    agent.redirect_ok = false
    page = agent.get('http://demo.screenster.io/authenticate/signin')

    button = page.form.button_with(class: 'btn btn btn-primary')

    page = page.form do |form|
      form.email = params['login']
      form.password = params['password']
    end.submit(button)

    flash = agent.cookies.find{|c|c.name=='PLAY_FLASH'}
    if flash and flash.value.include? 'Invalid+email'
      raise 'Invalid email/password'
    end

    page = agent.get page.header['location']

    byebug

  end

end
