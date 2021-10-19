# Deduplicate Phoenix authentication tests with macros

This repo contains a working example for deduplicating authentication tests in Phoenix by using Elixir `macros`. You can read the accompanying article here:
- https://medium.com/@m.r.nijboer/deduplicating-authentication-and-authorization-tests-in-elixir-and-phoenix-using-macros-5ed7fe5c282d
- https://dev.to/martinthenth/deduplicating-authentication-and-authorization-tests-in-elixir-and-phoenix-using-macros-5c2c

A summary: The number of authentication and authorization tests for Phoenix controller actions can go into the hundreds and thousands. The problem is that these tests are near-identical, and manually writing and updating these tests is error-prone and laborous. Instead, I offer a solution using Elixir `macros` that generate these tests for us.

A `macro` contains the authentication tests we need, and adapts to the arguments (e.g. the `route`) we give it. We implement the `macro` in a `ControllerTest`. On running tests with `mix test`, the `macro` expands into the defined tests. 

## Macro definition and implementation.

- For the `macro` that replaces authentication tests, look in `/test/support/macros/authentication_tests_macro.ex`
- For the `macro` implementation in a controller, look in `/test/deduplicate_web/controllers/user_controller_test.exs`

## What can you do with test macros?
This example repository contains a macro for authentication tests. You could easily adapt this `macro` for authorization tests. Thus, you can test whether `User` is authenticated, but also whether `User` should access a `Post` or `Team` or `Team.Member` object.
