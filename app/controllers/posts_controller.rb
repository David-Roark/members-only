class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order('created_at DESC')
    @post = Post.new
    @new_members = User.last(5)

    unless user_signed_in?
      @posts.map{ |post| set_anonymous(post.user) }
      @new_members.map{ |member| set_anonymous(member) }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = @post.comments
    @comment = Comment.new

    unless user_signed_in?
      set_anonymous(@post.user)
      @comments.map{ |comment| set_anonymous(comment.user) }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        errors = @post.errors.full_messages.join('! ')
        format.html { redirect_to root_path, alert: "Post was failly created!\n#{errors}!" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_path(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        errors = @post.errors.full_messages.join('! ')
        format.html { redirect_to edit_post_path(@post), alert: "Post was failly updated!\n#{errors}!" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body)
    end

    def set_anonymous(user)
      user.email = 'example@example.com'
      user.name = 'Anonymous'
    end
end
