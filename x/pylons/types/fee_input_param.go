package types



// Has validate if input is between min max range
func (lp FeeInputParam) Has(input int64) bool {
	// it means fee restriction is not set
	if lp.MinValue == 0 && lp.MaxValue == 0 {
		return true
	}
	return input >= lp.MinValue && input <= lp.MaxValue
}
