module Mutations
  class DeleteArticle < GraphQL::Schema::RelayClassicMutation
    field :article, Types::ArticleType, null: false

    argument :id, ID, required: true

    def resolve(id:)
        Article.find(id).destroy! unless Article.find(id).nil?
        { article: article }
    end
  end
end
