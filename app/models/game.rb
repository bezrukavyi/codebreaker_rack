class Game < Codeguessing::Game
  def initialize(opt = {})
    @secret_code = opt[:secret_code] || random
    @attempts = opt[:attempts] || MAX_ATTEMPTS
    @hint_count = opt[:hint_count] || MAX_HINT
    @state = opt[:state] || ''
    @answer = opt[:answer] || ''
  end
end
