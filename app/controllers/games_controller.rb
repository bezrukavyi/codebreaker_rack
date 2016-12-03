class GamesController < BaseController

  attr_reader :game, :hint, :request, :scores

  def initialize(env)
    @request = Rack::Request.new env
    @game = Game.new(parse_opt)
    @path = File.absolute_path('data/scores.yml')
    @scores = load(@path)
  end

  def new
    @game = Game.new
    set_opt
    redirect_to '/play'
  end

  def index
    render 'game/index'
  end

  def play
    @hint = game.hint if request.params['hint']
    game_exist? ? set_opt(parse_opt[:last_guess]) : set_opt
    @game_opt = parse_opt
    render 'game/play'
  end

  def update
    game.guess(guess_params) if request.params['guess']
    set_opt
    redirect_to '/play'
  end

  def rules
    render 'game/rules'
  end

  def save(path = @path)
    name = request.params['player'] || 'Anonim'
    @scores << game.cur_score(name)
    File.new(path, 'w') unless File.exist?(path)
    File.open(path, "r+") do |f|
      f.write(@scores.to_yaml)
    end
    clear_opt
    redirect_to '/'
  end

  def game_exist?
    game_option = request.session[:game]
    return false if game_option.nil? || game_option.empty?
    true
  end

  private
  def parse_opt
    return {} unless game_exist?
    JSON.parse( request.session[:game], {:symbolize_names => true} )
  end

  def load(path)
    return [] unless File.exist?(path)
    YAML.load(File.open(path))
  end

  def guess_params
    guess = request.params['guess']
    return [] if guess.nil? || guess.empty?
    guess.join('')
  end

  def clear_opt
    request.session[:game].clear
  end

  def set_opt(last_guess = guess_params)
    cur_game = game.cur_game
    cur_game[:last_guess] = last_guess
    @request.session[:game] = cur_game.to_json
  end

  def end_game
    if game.state == 'true'
      return redirect_to '/new'
    elsif game.state == 'false'
      return redirect_to '/'
    end
  end

end
