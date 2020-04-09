# coding: utf-8
require 'homebus'
require 'homebus_app'
require 'mqtt'
require 'dotenv'

require 'open-uri'

require 'nokogiri'
require 'json'

class GoFundMeHomebusApp < HomeBusApp
  DDC = 'org.homebus.experimental.gofundme'

  def initialize(options)
    @options = options
    super
  end

  def update_delay
    5*60
  end

  def setup!
    Dotenv.load('.env')
    @gofundme_url = ENV['GOFUNDME_URL']
  end

  def _get_gofundme
    begin
      results = URI.parse(@gofundme_url).read

      puts results

      document = Nokogiri::HTML(results)
      # $5,000
      raised = document.at('.raised').text
      raised.gsub!(/\D/, '')

      # of $10,000 goal
      goal = document.at('.goal').text
      goal.gsub!(/\D/, '')

      # Raised by 9 people in   2 days
      raised_by = document.at('.raised-by').text

      m = raised_by.match /Raised by (\d+) people in\s+(\d+)/
      if m
        people = m[1]
        days = m[2]
      end

      return {
        status: :success,
        raised: raised.to_i,
        goal: goal.to_i,
        people: people.to_i,
        days: days.to_i
      }
    rescue
      nil
    end
  end

  def work!
    gofundme_status = _get_gofundme
    pp gofundme_status

    answer =  {
      id: @uuid,
      timestamp: Time.now.to_i
    }

    if gofundme_status
      answer[DDC] =  gofundme_status
    else
      answer[DDC] = { status: :failure }
    end

    publish! DDC, answer

    sleep update_delay
  end

  def manufacturer
    'HomeBus'
  end

  def model
    'GoFundMe Scraper'
  end

  def friendly_name
    ''
  end

  def friendly_location
    ''
  end

  def serial_number
    @gofundme_url
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: 'GoFundMe scraper',
        friendly_location: 'Portland, OR',
        update_frequency: update_delay,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ DDC ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
