# Refactor Rails 3.2.22.4 controller

TODO: Please refactor `app/controllers/gigs/inquiries_controller.rb` as you like and
explain your changes.

What was done:

 - `inquiries_controller.rb` #new and #create domain logic
  was moved into corresponding services to process that data
 - left a comment at `Gigmit::Concern::Negotiation`

Also I would like to propose to normalize the DB. Reading schema comes out that
`gigs` and `inquiries` tables *knows* to many redundant data that could harm
data consistency. Just for example gigs have such fields that are better to separate
into another table:
  ```
  "deal_split_amount_for_promoter"
  "deal_possible_fee_min"
  "deal_possible_fee_max"
  "deal_guaranteed_artist_fee"
  "deal_break_even_point"
  "deal_fee_max"
  "deal_possible_fee_tax"
  ```

In case if it is will harm performance, I would propose
to use Elasticsearch API for denormalizing data.
