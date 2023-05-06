@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Read-only view from /DMO/I_BOOKING_U'
@Metadata.allowExtensions: true
define view entity Z_I_BOOKING_011
  as select from /DMO/I_Booking_U as Booking
  association        to parent Z_I_TRAVEL_R_011 as _Travel     on $projection.TravelID = _Travel.TravelID
  association [1..1] to /DMO/I_Connection       as _Connection on $projection.ConnectionID = _Connection.ConnectionID
{
  key TravelID,
  key BookingID,
      BookingDate,
      CustomerID,
      AirlineID,
      ConnectionID,
      FlightDate,

      @Semantics.amount.currencyCode: 'Currency_Code'
      FlightPrice              as Flight_Price,

      CurrencyCode             as Currency_Code,

      @Semantics.quantity.unitOfMeasure: 'DistanceUnit'
      _Connection.Distance     as Distance,

      _Connection.DistanceUnit as DistanceUnit,
      case
    when _Connection.Distance >= 2000 then 'long-haul flight'
    when _Connection.Distance >= 1000 and
     _Connection.Distance <  2000 then 'medium-haul flight'
    when _Connection.Distance <  1000 then 'short-haul flight'
                      else 'error'
end                      as Flight_type,

      LastChangedAt,
      /* Associations */
      _BookSupplement,
      _Carrier,
      _Connection,
      _Customer,
      _Travel

}
where
_Connection.DistanceUnit = 'KM'
