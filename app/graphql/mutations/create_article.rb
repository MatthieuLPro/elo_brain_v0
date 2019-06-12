module Mutations
  class CreateArticle < GraphQL::Schema::RelayClassicMutation
    field :article, Types::ArticleType, null: false

    argument :title, String, required: true
    argument :description, String, required: true

    def resolve(title:, description:)
        article = Article.create!(title: title, description: description)
        {
            article: article
        }
    end 
  end
end
