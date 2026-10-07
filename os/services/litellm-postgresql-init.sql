ALTER DATABASE litellm OWNER TO sfangyy;
GRANT ALL PRIVILEGES ON DATABASE litellm TO sfangyy;
\connect litellm
ALTER SCHEMA public OWNER TO sfangyy;
GRANT ALL ON SCHEMA public TO sfangyy;
