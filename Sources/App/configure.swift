import FluentSQLite
import Vapor

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
  ) throws {
  
  try configureSQLite(&config, &env, &services)
}
