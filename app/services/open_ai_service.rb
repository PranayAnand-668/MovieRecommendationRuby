require 'openai'

class OpenAiService
  def initialize
    api_key = ENV['OPENAI_API_KEY']
    raise "OpenAI API key not found. Set it in your .env.local file." unless api_key

    @client = OpenAI::Client.new(access_token: api_key)
  end

  def fetch_movie_recommendations(prompt)
    attempts = 0
    max_attempts = 3

    begin
      sleep(1)
      response = @client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "You are a movie recommendation assistant." },
            { role: "user", content: prompt }
          ],
          max_tokens: 300
        }
      )
      
      parse_recommendations(response)
    rescue OpenAI::Error => e
      if e.message.include?("429") && attempts < max_attempts
        Rails.logger.warn "Rate limit exceeded. Retrying (#{attempts + 1}/#{max_attempts})..."
        attempts += 1
        sleep(2)
        retry
      else
        Rails.logger.error "Error fetching recommendations: #{e.message}"
        []
      end
    end
  end

  private

  def parse_recommendations(response)
    choices = response.dig("choices") || []
    recommendations = choices.first&.dig("message", "content")
    return recommendations&.split("\n") || [] if recommendations.present?

    Rails.logger.warn "No recommendations found in response: #{response.inspect}"
    []
  end
end

