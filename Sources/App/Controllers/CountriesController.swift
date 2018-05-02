import Vapor
import VaporCountries
import FluentSQLite

//need to add those protocol conformances
extension Country : Parameter{}
extension Country : Content{}

extension Continent : Parameter{}
extension Continent : Content{}

public typealias CountrySQLite = Country<SQLiteDatabase>
public typealias ContinentSQLite = Continent<SQLiteDatabase>

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
