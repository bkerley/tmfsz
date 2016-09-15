defmodule Tmfsz.Repo.Migrations.FullTextIndex do
  use Ecto.Migration

  def up do
    execute """
    CREATE MATERIALIZED VIEW search_tweets AS
    SELECT to_tsvector('english',
                       text || ' ' || coalesce(caption, ' ')) as tsv,
           *
      FROM tweets;
    """

    execute "CREATE UNIQUE INDEX ON search_tweets (id)"
    execute "CREATE UNIQUE INDEX ON search_tweets (id_number)"
    execute """
    CREATE INDEX search_tweets_text
    ON search_tweets
    USING GIN (tsv);
    """

    execute """
    CREATE FUNCTION search_tweets_refresh() RETURNS trigger AS
    $$
    BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY search_tweets;
      RETURN new;
    END;
    $$
    LANGUAGE plpgsql
    """

    execute """
    CREATE TRIGGER search_tweets_refresh_on_tweets
      AFTER INSERT OR UPDATE ON tweets
      FOR EACH STATEMENT
      EXECUTE PROCEDURE search_tweets_refresh();
      """

    execute "REFRESH MATERIALIZED VIEW CONCURRENTLY search_tweets;"
  end

  def down do
    execute "DROP TRIGGER IF EXISTS search_tweets_refresh_on_tweets ON tweets;"
    execute "DROP FUNCTION IF EXISTS search_tweets_refresh();"
    execute "DROP MATERIALIZED VIEW IF EXISTS search_tweets;"
  end
end
