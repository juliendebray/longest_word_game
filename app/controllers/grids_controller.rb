class GridsController < ApplicationController
  def game
    @grid = generate_grid(9)
    @start_time = Time.now
    session[:count] ? session[:count] += 1 : session[:count]=1

  end

  def score
    @user_input = params[:user_input]
    @elapsed_time = (Time.now - Time.parse(params[:start_time]))/1000
    @initial_grid = params[:initial_grid]
    @result = score_and_message(@user_input, true, @initial_grid, @elapsed_time)
  end

  private
  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def included?(guess, grid)
    guess.split("").all? { |letter| grid.include? letter }
  end

  def compute_score(attempt, time_taken)
    (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score_and_message(attempt, translation, grid, time)
    if translation
      if included?(attempt.upcase, grid)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not in the grid"]
      end
    else
      [0, "not an english word"]
    end
  end

end
