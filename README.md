## mass-spring-sim-3D
Mass spring simulation for processing

# Structure File Syntax

	garvity gravitry-Value(should be a negative)

	springDampeningConst dampening-Value (should be a negative)

	viscousDampeningConst dampening-Value 

	ballRadius radius-Value

	To create a MassBall:
		massBall starting-X-position starting-Y-Position tarting-Z-Position friction mass

	To create a Spring:
		spring spring-Constant rest-length phase magnitude massBall-index massBall-index (massBall indices are in the order you added them)

	To create a Rod:
		rod rest-length massBall-index massBall-index