class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = Comment.new(comment_params)
    comment.user_id = current_user.id

    if comment.save
      redirect_back fallback_location: movies_path,
                    notice: t('comment.created')
    else
      redirect_back fallback_location: movies_path,
                    alert: error_messages(comment)
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    if current_user == comment.user
      comment.destroy
      redirect_back fallback_location: movies_path,
                    notice: t('comment.deleted')
    else
      redirect_back fallback_location: movies_path,
                    alert: t('comment.delete_own')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :body, :movie_id)
  end

  def error_messages(comment)
    comment.errors.full_messages.to_sentence
  end
end
