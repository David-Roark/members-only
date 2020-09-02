class CommentsController < ApplicationController
  before_action :authenticate_user!

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to "/posts/#{@comment.post_id}" }
        format.json { render :show, status: :created, location: @comment }
      else
        errors = @comment.errors.full_messages.join('! ')
        format.html { redirect_to "/posts/#{@comment.post_id}", alert: "Comment was failly created!\n#{errors}!" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end


  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_path(@comment.post), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
