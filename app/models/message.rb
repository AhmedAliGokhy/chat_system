class Message < ApplicationRecord
  # Associations
  belongs_to :chat

  # Validations
  validates :number, presence: true
  validates :number, uniqueness: { scope: :chat }

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

  def self.search_body(chat_id, body)
    self.search({
      "query": {
            "bool": {
                "must": [
                    {
                        "wildcard": {
                            "body": {
                                "value": "*#{body}*"
                            }
                        }
                    },
                    {
                        "match": {"chat_id": chat_id}
                    }
                ]
            }
            
        }
    }).records.records
  end
end
