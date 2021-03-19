class Message < ApplicationRecord
  belongs_to :chat

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings analysis: {
    filter: {
      ngram_filter: { type: "edge_ngram", min_gram: 1, max_gram: 20 }
    },
    analyzer: {
          index_ngram_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'ngram_filter']
          },
          search_ngram_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'ngram_filter']
          }
      }
  } do
    mapping do 
      indexes :body, type: :text, analyzer: "index_ngram_analyzer", search_analyzer: "search_ngram_analyzer"
    end
  end
end
