module Types
  class QueryType < Types::BaseObject
    field :allArticles, [ArticleType], null: false

    field :article, ArticleType, null: true do
      argument :id, ID, required: true
    end

    def all_articles
      Article.all
    end

    def article(id:)
    	Article.find(id)
    end
  end
end
