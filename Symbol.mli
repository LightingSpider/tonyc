(* Symbol table *)
type pass_mode = PASS_BY_VALUE | PASS_BY_REFERENCE

type param_status =
  | PARDEF_COMPLETE                             (* ������ �������     *)
  | PARDEF_DEFINE                               (* �� ���� �������    *)
  | PARDEF_CHECK                                (* �� ���� �������    *)

type scope = {
  sco_parent : scope option;
  sco_nesting : int;
  mutable sco_entries : entry list;
  mutable sco_negofs : int;
  mutable sco_frame_place : int
}

and variable_info = {
  variable_type         : Types.typ;
  variable_offset       : int;
  variable_frame_place  : int
}

and function_info = {
  mutable function_isForward  : bool;
  mutable function_paramlist  : entry list;
  mutable function_redeflist  : entry list;
  mutable function_result     : Types.typ;
  mutable function_pstatus    : param_status;
  mutable function_initquad   : int;
  mutable var_type_list       : entry_info list
}


and parameter_info = {
  parameter_type           : Types.typ;
  mutable parameter_offset : int;
  parameter_mode           : pass_mode;
  parameter_frame_place    : int

}

and temporary_info = {
  temporary_type   : Types.typ;
  temporary_offset : int
}

and entry_info = ENTRY_none
               | ENTRY_variable of variable_info
               | ENTRY_function of function_info
               | ENTRY_parameter of parameter_info
               | ENTRY_temporary of temporary_info

and entry = {
  entry_id    : Identifier.id;
  entry_scope : scope;
  entry_info  : entry_info
}

type lookup_type = LOOKUP_CURRENT_SCOPE | LOOKUP_ALL_SCOPES

val currentScope : scope ref              (* �������� ��������         *)
val quadNext : int ref                    (* ������� �������� �������� *)
val tempNumber : int ref                  (* �������� ��� temporaries  *)

val initSymbolTable  : int -> unit
val openScope        : unit -> unit
val closeScope       : unit -> unit

(*if bool is False we are sure that this name HAS NOT already used*)
val newVariable      : Identifier.id -> Types.typ -> entry_info -> bool -> entry
val newFunction      : Identifier.id -> bool -> entry
val newParameter     : Identifier.id -> Types.typ -> pass_mode ->
                                      entry -> bool -> entry
val newTemporary     : Types.typ -> entry


val forwardFunction   : entry -> unit
val functionHeaderEnd : entry -> Types.typ -> unit
val lookupEntry       : Identifier.id -> lookup_type -> bool -> entry

val start_positive_offset : int   (* ������ ������ offset ��� �.�.   *)
val start_negative_offset : int   (* ������ �������� offset ��� �.�. *)
