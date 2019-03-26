require "rails_helper"

RSpec.describe TopCommenters do
  describe "#call" do
    let(:service) { described_class.new }
    let(:sql) { service.call.to_sql }

    it "generates valid SQL" do
      expect { service.call }.not_to raise_error
    end

    it "generates expected SQL" do
      Timecop.freeze(Time.zone.now) do
        expect(sql.squish).to eq(<<-SQL.squish)
          SELECT  "users".* FROM "users" INNER JOIN "comments"
          ON "comments"."user_id" = "users"."id" WHERE
          (comments.created_at >= '#{1.week.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")}')
          GROUP BY users.id ORDER BY count(comments.id) DESC LIMIT 10
        SQL
      end
    end
  end
end
