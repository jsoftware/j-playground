NB. demo2

load 'convert/pjson'

cocurrent 'pjson'

A=: 0 : 0
[
    {
        "Name": "Alabama",
        "Code": "AL",
        "Capital": "Montgomery",
        "Statehood": "December 14, 1819",
        "Population": 4833722,
        "Area": 52420,
        "House Seats": 7
    }, {
        "Name": "Alaska",
        "Code": "AK",
        "Capital": "Juneau",
        "Statehood": "January 3, 1959",
        "Population": 735132,
        "Area": 665384,
        "House Seats": 1
    }, {
        "Name": "Arizona",
        "Code": "AZ",
        "Capital": "Phoenix",
        "Statehood": "February 14, 1912",
        "Population": 6626624,
        "Area": 113990,
        "House Seats": 9
    }, {
        "Name": "Arkansas",
        "Code": "AR",
        "Capital": "Little Rock",
        "Statehood": "June 15, 1836",
        "Population": 2959373,
        "Area": 53179,
        "House Seats": 4
    }
]
)

dec A
(dec A) -: dec enc dec A
