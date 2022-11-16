# BLE GATT TABLE PROTOCOL:

## GATT IDs:

0998XXXX-1280-49A1-BACF-965209262E66 where XXXX is the CHAR ID, 0000 for the SERVICE ID

## GATT TABLE LAYOUT:

| MEANING  	          |CHAR ID   	 |DATA TYPE              |PERMISSIONS |DESCRIPTION | 	
|---	              |---	         |---                    |---         |---
|STATUS               |0x0001        |bitmap - 32 bits       |READ        |bit 0 = accelerometer connected, bit 1 = additional memory connected 
|SET_THRESHHOLD       |0x0002        |uint32_t               |WRITE       |Acceleration threshhold for crash determination, 0 when not tracking
|DATA_AVAILABLE       |0x0003        |uint32_t               |READ NOTIFY |Increment each time a new set of crash data is available
|CRASH_DATA           |0x0010-0x0060 |struct data_point[85]  |READ        |Accelerometer data from crash in chunks of 85 data_points - floor(512/6 bytes)

```C
struct data_point {
    int16_t value; // value recorded by accelerometer
    int32_t time;  // clock time, not real time
}
```
