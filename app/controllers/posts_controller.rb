class PostsController < ApplicationController
  before_action :set_post, only: [:cancel]

  def new
    if current_user.connections.any?
      @post = Post.new
    else
      redirect_to dashboard_path, notice: "Please connect to twitter first"
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.twitter = true
    respond_to do |format|
      if @post.save
        format.html {redirect_to dashboard_path, notice: "Your post was successfully created!"}
      else
        format.html {render :new}
      end
    end
  end

  def cancel
    @post.update_attributes(state: 'canceled')
    redirect_to dashboard_path, notice: 'The post was successfully cancelled'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :scheduled_at, :state, :user_id, :facebook, :twitter)
  end

end
