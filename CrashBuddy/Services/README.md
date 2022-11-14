# BLE GATT TABLE PROTOCOL:

## GATT IDs:

0998XXXX-1280-49A1-BACF-965209262E66 where XXXX is the CHAR ID, 0000 for the SERVICE ID

## GATT TABLE LAYOUT:

| MEANING  	          |CHAR ID   	 |DATA TYPE              |PERMISSIONS |DESCRIPTION | 	
|---	              |---	         |---                    |---         |---
|ACCEL_STATUS         |0x0001        |bitmap - 32 bits       |READ        |0th = accelerometer connected
|MEM_STATUS           |0x0002        |bitmap - 32 bits       |READ        |0th = accelerometer connected
|SET_THRESHHOLD       |0x0003        |uint32_t               |WRITE       |Acceleration threshhold for crash determination
|DATA_AVAILABLE       |0x0004        |uint32_t               |READ        |Increment each time a new set of crash data is available
|DATA_SIZE            |0x0005        |uint32_t               |READ        |total # of data characteristics available to be read
|CRASH_DATA           |0x0010-0x0060 |struct data_point[124] |READ        |Accelerometer data from crash in chunks of 124 data_points

```C
struct data_point {
    int16_t value; // value recorded by accelerometer
    int32_t time;  // clock time, not real time
}
```
