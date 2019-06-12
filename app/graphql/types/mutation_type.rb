module Types
  class MutationType < Types::BaseObject
    field :deleteArticle, mutation: Mutations::DeleteArticle
    field :createArticle, mutation: Mutations::CreateArticle
  end
end
