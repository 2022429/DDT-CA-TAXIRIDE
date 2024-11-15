//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TaxiRide contract manages ride bookings and payments for a taxi driver
contract TaxiRide {

// Address of the contract deployer, considered as the driver
    address public driver; 
	
	// Tracks the total earnings of the driver
    uint public driverBalance; 

    // Structure representing a ride's details like pickup and price of the ride in wei
    struct Ride {
        string location;  
        uint price;       
        
    }

// Maps each ride to a unique ID and number of rides count and unique id
    mapping(uint => Ride) public rides; 
    uint public rideCount; 

    // Events to log actions, visible on the blockchain and New ride added ,ride book , payment received.
    event RideAdded(uint rideId, string location, uint price); 
    event RideBooked(address passenger, uint rideId, uint totalCost); 
    event PaymentReceived(address passenger, uint amount); 

    // Modifier to restrict certain functions to the driver only
        modifier onlyDriver() {
	// Proceeds with the function if the caller is the driver
        require(msg.sender == driver, "Only the driver can perform this action.");
        _; 
}
    // Constructor to set the contract deployer as the driver
    constructor() {
        driver = msg.sender;
    }

    // Function to add a new ride with location and price, callable only by the driver and store new ride details, log the ride details 

    function addRide(string memory _location, uint _price) public onlyDriver {
        rides[rideCount] = Ride(_location, _price); 
        emit RideAdded(rideCount, _location, _price);
		// Increments ride count for the next unique ID
          riderCount++;
    }

    // Function to book a ride, sending the required payment to the contract and ensure the rider id exists and rider details
    function bookRide(uint _rideId) public payable {
        require(_rideId < rideCount, "Invalid ride ID."); 
        Ride storage ride = rides[_rideId]; 

    // Sets the total cost of the ride and check the exact payment was sent
        uint totalCost = ride.price; 
        require(msg.value == totalCost, "Incorrect payment amount."); 

        driverBalance += msg.value; 
    // Logs the booking details and payment recieved
        emit RideBooked(msg.sender, _rideId, totalCost); 
        emit PaymentReceived(msg.sender, msg.value); 
    }

    // Function for the driver to withdraw their accumulated balance
    function withdrawBalance() public onlyDriver {
	// Gets the current balance available for withdrawal
        uint amount = driverBalance; 
		// Resets the driver's balance after withdrawal
        driverBalance = 0; 
		// Transfers the balance to the driver
        payable(driver).transfer(amount); 
    }

    // Function to view the details of a specific ride by its ID ensure rider id exists and fetches ride details and return location and price of the ride
    function getRideDetails(uint _rideId) public view returns (string memory location, uint price) {
        require(_rideId < rideCount, "Invalid ride ID."); 
        Ride memory ride = rides[_rideId]; 
        return (ride.location, ride.price); 
    }
}
