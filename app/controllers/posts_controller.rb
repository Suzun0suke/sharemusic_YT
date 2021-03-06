class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :ranking, :search]
  before_action :post_set, only:[:show, :edit, :update, :destroy]
  before_action :move_to_index, only:[:edit, :destroy]
  
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc).page(params[:page]).per(6)
    if params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).per(6)
    end
  end

  def new
    @post = PostMusic.new
  end

  def create
    @post = PostMusic.new(post_params)
    if @post.valid?
      @post.save
      flash[:notice] = '投稿が完了しました'
      redirect_to root_path
    else
      flash.now[:alert] = '無効なURL、あるいは入力されていない項目があります'
      render :new
    end
  end

  def show
    
  end

  def edit

  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path
    end
  end

  def search
    @posts = Post.search(params[:keyword])
    if @posts.present?
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(6)
    end
  end

  def ranking
    @like_posts = Post.find(Like.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))
    @tags = Post.tag_counts_on(:tags).most_used(5)
  end

  private

  def post_params
    params.require(:post_music).permit(:title, :url, :image, :tag_list).merge(user_id: current_user.id)
  end

  def post_set
    @post = Post.find(params[:id])
  end

  def move_to_index
    if current_user.id != @post.user_id
      redirect_to root_path
    end
  end

end
