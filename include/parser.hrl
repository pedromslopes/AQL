% select
-define (SELECT_TOKEN, select).
-define(SELECT_CLAUSE(TokenChars), {?SELECT_TOKEN, TokenChars}).
%% from
-define(FROM_TOKEN, from).
-define(FROM_CLAUSE(TokenChars), {?FROM_TOKEN, TokenChars}).

% where
-define(WHERE_TOKEN, where).
-define(WHERE_CLAUSE(TokenChars), {?WHERE_TOKEN, TokenChars}).
%% and
-define(CONJUNCTIVE_TOKEN, conjunctive).
-define(CONJUNCTIVE_KEY(TokenChars), {?CONJUNCTIVE_TOKEN, TokenChars}).

% insert
-define(INSERT_TOKEN, insert).
-define(INSERT_CLAUSE(TokenChars), {?INSERT_TOKEN, TokenChars}).
%% into
-define(INTO_TOKEN, into).
-define(INTO_KEY(TokenChars), {?INTO_TOKEN, TokenChars}).

% create
-define(CREATE_TOKEN, create).
-define(CREATE_CLAUSE(TokenChars), {?CREATE_TOKEN, TokenChars}).
%% table
-define(TABLE_TOKEN, table).
-define(TABLE_KEY(TokenChars), {?TABLE_TOKEN, TokenChars}).
%% values
-define(VALUES_TOKEN, values).
-define(VALUES_CLAUSE(TokenChars), {?VALUES_TOKEN, TokenChars}).
%% primary key constraint
-define(PRIMARY_TOKEN, primary).
-define(PRIMARY_KEY(TokenChars), {?PRIMARY_TOKEN, TokenChars}).
-define(KEY_TOKEN, key).
-define(KEY_KEY(TokenChars), {?KEY_TOKEN, TokenChars}).
%% check constraint
-define(CHECK_TOKEN, check).
-define(CHECK_KEY(TokenChars), {?CHECK_TOKEN, TokenChars}).
-define(COMPARATOR_TOKEN, comparator).
-define(GREATER_TOKEN, greater).
-define(GREATER_KEY, {?COMPARATOR_TOKEN, ?GREATER_TOKEN}).
-define(SMALLER_TOKEN, smaller).
-define(SMALLER_KEY, {?COMPARATOR_TOKEN, ?SMALLER_TOKEN}).
%% attributes
-define(ATTR_TYPE_TOKEN, attribute_type).
-define(ATTR_KEY(AttrType), {?ATTR_TYPE_TOKEN, AttrType}).
%% table policies
-define(TABLE_POLICY_TOKEN, table_policy).
-define(TABLE_POLICY_KEY(Crp), {?TABLE_POLICY_TOKEN, Crp}).

% udpate
-define(UPDATE_TOKEN, update).
-define(UPDATE_CLAUSE(TokenChars), {?UPDATE_TOKEN, TokenChars}).
%% set
-define(SET_TOKEN, set).
-define(SET_CLAUSE(TokenChars), {?SET_TOKEN, TokenChars}).
%%% set ops
-define(ASSIGN_TOKEN, assign).
-define(ASSIGN_OP(TokenChars), {?ASSIGN_TOKEN, TokenChars}).
-define(INCREMENT_TOKEN, increment).
-define(INCREMENT_OP(TokenChars), {?INCREMENT_TOKEN, TokenChars}).
-define(DECREMENT_TOKEN, decrement).
-define(DECREMENT_OP(TokenChars), {?DECREMENT_TOKEN, TokenChars}).

%terms
-define(PARSER_ATOM, atom_value).
-define(PARSER_STRING, string).
-define(PARSER_NUMBER, number).

% extras
-define(PARSER_EQUALITY, {equality, ignore}).
-define(PARSER_WILDCARD, {wildcard, ignore}).

-define(PARSER_SLIST, {start_list, ignore}).
-define(PARSER_ELIST, {end_list, ignore}).
-define(PARSER_SEP, {sep, ignore}).
-define(PARSER_SCOLON, {semi_colon, ignore}).
