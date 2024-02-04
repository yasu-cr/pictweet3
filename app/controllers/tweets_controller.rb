class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @tweets = Tweet.includes(:user).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)
    #バリデーションに引っかからず保存されれば、トップページにリダイレクトする
    if @tweet.save
      redirect_to '/'
    else
      #バリデーションに引っかかり保存されなければ、「新規投稿」の画面を呼び出す
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to root_path
  end

  def edit
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def update
    @tweet = Tweet.find(params[:id])
    #バリデーションに引っかからず更新されれば、トップページにリダイレクトする
    if @tweet.update(tweet_params)
      redirect_to root_path
    else
      #バリデーションに引っかかり保存されなければ、「編集」の画面が呼び出される
      render 'edit', status: :unprocessable_entity
    end
  end

  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private  # private以下の記述はすべてプライベートメソッドになる
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
