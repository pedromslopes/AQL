%%%-------------------------------------------------------------------
%%% @author joao
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. ago 2017 16:01
%%%-------------------------------------------------------------------
-module(policy_SUITE).
-author("joao").

-include_lib("aql.hrl").
-include_lib("parser.hrl").
-include_lib("types.hrl").

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([init_per_suite/1,
        end_per_suite/1,
        init_per_testcase/2,
        end_per_testcase/2,
        all/0]).

%% API
-export([one_level/1,
        two_levels/1,
        three_levels/1]).

init_per_suite(Config) ->
  %aql:start(),
  Config.

end_per_suite(Config) ->
  %aql:stop(),
  Config.

init_per_testcase(_Case, Config) ->
  Config.

end_per_testcase(_, _) ->
  ok.

all() ->
  [
    one_level,
    two_levels,
    three_levels
  ].

create_crp(TableLevel) ->
  crp:set_table_level(TableLevel, crp:new()).

create_crp(TableLevel, DepLevel) ->
  crp:set_dep_level(DepLevel, create_crp(TableLevel)).

create_crp(TableLevel, DepLevel, PDepLevel) ->
  crp:set_p_dep_level(PDepLevel, create_crp(TableLevel, DepLevel)).

create_query(TName, CRP) ->
  lists:concat(["CREATE ", CRP, " TABLE ", TName, " (ID INTEGER PRIMARY KEY);\n"]).

create_query(TName, [TTName1, TTName2], TableLevel, DepLevel) ->
  lists:concat(["CREATE ", TableLevel, " TABLE ", TName,
    " (ID INTEGER PRIMARY KEY, ",
    "  FKA INTEGER FOREIGN KEY ", DepLevel, " REFERENCES ", TTName1, "(ID),",
    "  FKB INTEGER FOREIGN KEY ", DepLevel, " REFERENCES ", TTName2, "(ID));\n"]);
create_query(TName, TTName, TableLevel, DepLevel) ->
  lists:concat(["CREATE ", TableLevel, " TABLE ", TName,
    " (ID INTEGER PRIMARY KEY, ",
    "  FK INTEGER FOREIGN KEY ", DepLevel, "REFERENCES ", TTName, "(ID));\n"]).

one_level(_Config) ->
  AWTName = "LAAw",
  RWTName = "LARw",
  AWQuery = create_query(AWTName, "UPDATE-WINS"),
  RWQuery = create_query(RWTName, "DELETE-WINS"),
  {ok, [], _Tx} = tutils:aql(lists:concat([AWQuery, RWQuery])),
  tutils:assert_table_policy(create_crp(?ADD_WINS), AWTName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS), RWTName).

two_levels(_Config) ->
  AwTName = "LBAAw",
  RwTName = "LBARw",
  AwFrTName = "LBBAwFr",
  AwIrTName = "LBBAwIr",
  RwFrTName = "LBBRwFr",
  RwIrTName = "LBBRwIr",
  {ok, [], _Tx} = tutils:aql(lists:concat([
    create_query(AwTName, "UPDATE-WINS"),
    create_query(RwTName, "DELETE-WINS"),
    create_query(AwFrTName, AwTName, "UPDATE-WINS", "UPDATE-WINS"),
    create_query(AwIrTName, RwTName, "UPDATE-WINS", "DELETE-WINS"),
    create_query(RwFrTName, AwTName, "DELETE-WINS", "UPDATE-WINS"),
    create_query(RwIrTName, RwTName, "DELETE-WINS", "DELETE-WINS")])),
  tutils:assert_table_policy(create_crp(?ADD_WINS, undefined, ?ADD_WINS), AwTName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, undefined, ?REMOVE_WINS), RwTName),
  tutils:assert_table_policy(create_crp(?ADD_WINS, ?ADD_WINS), AwFrTName),
  tutils:assert_table_policy(create_crp(?ADD_WINS, ?REMOVE_WINS), AwIrTName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, ?ADD_WINS), RwFrTName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, ?REMOVE_WINS), RwIrTName).

three_levels(_Config) ->
  % level1
  AwTName = "LCAAw",
  RwTName = "LCARw",
  % level 2
  AwFr1TName = "LCBAwFr",
  AwIr1TName = "LCBAwIr",
  RwFr1TName = "LCBRwFr",
  RwIr1TName = "LCBRwIr",
  % level 3
  AwIr2TName = "LCCAwIr",
  RwIr2TName = "LCCRwIr",
  AwFr2TName = "LCCAwFr",
  RwFr2TName = "LCCRwFr",
  {ok, [], _Tx} = tutils:aql(lists:concat([
    create_query(AwTName, "UPDATE-WINS"),
    create_query(RwTName, "DELETE-WINS"),
    create_query(AwFr1TName, RwTName, "UPDATE-WINS", "UPDATE-WINS"),
    create_query(AwIr1TName, AwTName, "UPDATE-WINS", "DELETE-WINS"),
    create_query(RwFr1TName, RwTName, "DELETE-WINS", "UPDATE-WINS"),
    create_query(RwIr1TName, AwTName, "DELETE-WINS", "DELETE-WINS"),
    create_query(AwIr2TName, [AwIr1TName, RwIr1TName], "UPDATE-WINS", "DELETE-WINS"),
    create_query(RwIr2TName, [AwIr1TName, RwIr1TName], "DELETE-WINS", "DELETE-WINS"),
    create_query(AwFr2TName, [AwFr1TName, RwFr1TName], "UPDATE-WINS", "UPDATE-WINS"),
    create_query(RwFr2TName, [AwFr1TName, RwFr1TName], "DELETE-WINS", "UPDATE-WINS")
  ])),
  tutils:assert_table_policy(create_crp(?ADD_WINS, undefined, ?REMOVE_WINS), AwTName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, undefined, ?ADD_WINS), RwTName),
  tutils:assert_table_policy(create_crp(?ADD_WINS, ?ADD_WINS, ?ADD_WINS), AwFr1TName),
  tutils:assert_table_policy(create_crp(?ADD_WINS, ?REMOVE_WINS, ?REMOVE_WINS), AwIr1TName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, ?ADD_WINS, ?ADD_WINS), RwFr1TName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, ?REMOVE_WINS, ?REMOVE_WINS), RwIr1TName),
  tutils:assert_table_policy(create_crp(?ADD_WINS, ?REMOVE_WINS), AwIr2TName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, ?REMOVE_WINS), RwIr2TName),
  tutils:assert_table_policy(create_crp(?ADD_WINS, ?ADD_WINS), AwFr2TName),
  tutils:assert_table_policy(create_crp(?REMOVE_WINS, ?ADD_WINS), RwFr2TName).
