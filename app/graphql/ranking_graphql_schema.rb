class RankingGraphqlSchema < GraphQL::Schema
  max_depth 10
  max_complexity 300
  default_max_page_size 20

  def 

  mutation(Types::MutationType)
  query(Types::QueryType)
end
