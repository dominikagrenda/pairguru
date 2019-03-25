class TopCommenters
  def initialize; end

  def call
    top_commenters
  end

  private

  def top_commenters
    User
    .joins(:comments)
    .group("users.id")
    .where("comments.created_at >= ?", 1.week.ago)
    .order("count(comments.id) DESC")
    .limit(10)
  end
end
