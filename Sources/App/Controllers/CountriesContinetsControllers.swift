import Vapor
import VaporCountries

//Choose you DB provider
import FluentSQLite
//import FluentPostgreSQL
//import FluentMySQL

//protocol conformances
extension Country : Parameter{}
extension Country : Content{}
extension Continent : Parameter{}
extension Continent : Content{}

//Typecast the generic model to appropriate DB type
public typealias CountrySQLite = Country<SQLiteDatabase>
public typealias ContinentSQLite = Continent<SQLiteDatabase>

//public typealias CountrySQLite = Country<MySQLDatabase>
//public typealias ContinentSQLite = Continent<MySQLDatabase>
//
//public typealias CountrySQLite = Country<PostgreSQLDatabase>
//public typealias ContinentSQLite = Continent<PostgreSQLDatabase>

struct CountriesController: RouteCollection {
  
  func boot(router: Router) throws {
    let aRoute = router.grouped("api", "countries")
    
    //GET /api/countries
    aRoute.get(use: getAllHandler)
    
    //GET /api/countries/:ID
    aRoute.get(CountrySQLite.parameter as PathComponentsRepresentable, use: getOneHandler)
    
    //GET /api/countries/:ID/continent
    aRoute.get(CountrySQLite.parameter as PathComponentsRepresentable, "continent", use: getContinentHandler)
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[Country<SQLiteDatabase>]> {
    return CountrySQLite.query(on: req).all()
  }
  
  func getOneHandler(_ req: Request) throws -> Future<CountrySQLite> {
    return try req.parameters.next(Country.self)
  }
  
  func getContinentHandler(_ req: Request) throws -> Future<ContinentSQLite> {
    return try req.parameters.next(CountrySQLite.self).flatMap(to: ContinentSQLite.self) { country in
      return try country.continent!.get(on: req)
    }
  }
  
}

struct ContinentsController: RouteCollection {
  
  func boot(router: Router) throws {
    let aRoute = router.grouped("api", "continets")
    
    //GET /api/continets
    aRoute.get(use: getAllHandler)
    
    //GET /api/continents/:continentID
    aRoute.get(ContinentSQLite.parameter, use: getOne)
    
    //GET /api/continents/:continentID/countries
    aRoute.get(ContinentSQLite.parameter, "countries", use: getCountriesHandler)
  }
  
  func getAllHandler(_ req: Request) throws -> Future<[ContinentSQLite]> {
    return Continent.query(on: req).all()
  }
  
  func getOne(_ req: Request) throws -> Future<ContinentSQLite> {
    return try req.parameters.next(Continent.self)
  }
  
  func getCountriesHandler(_ req: Request) throws -> Future<[CountrySQLite]> {
    return try req.parameters.next(ContinentSQLite.self).flatMap(to: [CountrySQLite].self) { continent in
      return try continent.countries.query(on: req).all()
    }
  }
  
}
