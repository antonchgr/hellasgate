ns
# The HellasGate sample database - V2

## Overview

Στην έκδοση αυτή έγιναν κάποιες αλλαγές ώστε να υπάρχει και περιεχόμενο και σε αγγλικά εκτός από αμιγώς ελληνικά που υπήρχε στην πρώτη έκδοση.
Επίσης αλλαγές έγιναν στην αρχικοποίηση των δεδομένων ώστε να μην υπάρχουν μεγάλα σε αριθμό γραμμών sql scripts.
Στην έκδοση αυτή δημιουργήθηκε μια νέα function η οποία μετατρέπει ελληνικές λέξεις σε αγγλικά σύμφωνα με το πρότυπο του ELOT.

## Installation 

Για την δημιουργία της βάσης θα πρέπει να εκτελεστούν με την εξής σειρά τα sql scripts που υπάρχουν στο φάκελο αυτό.

1. HellasGateV2.sql
2. HellasGateV2-Code.sql
3. HellasGateV2-SPCode.sql
4. HellasGateV2-Cities.sql
4. HellasGateV2-Streets.sql
5. HellasGateV2-Names.sql

Για την εισαγωγή των δεδομών θα πρέπει να εκτελεστεί η ReGenerateData stored procedure.

### ReGenerateData stored procedure

#### ReGenerateData Syntax

`[dfi].[ReGenerateData]
                    @numofCustomers int = 5000,
                    @numofSuppliers int = 500,
                    @numofEmployees int = 500,
                    @numofProducts int = 2000,
                    @numofShippers int = 200,
                    @numofOrders int = 100000,
                    @maxItemsInOrder int = 5,
                    @calendarstartdate date = null,
                    @calendarnumberofyears int = null`

#### ReGenerateData Parameters
| Parameter | Data Type | Default Value | Usage |
| :--- | :--- | :--- | :--- |
| @numofCustomers |	int |	5000 | Ορίζει τον αριθμό των εγγραφών που θα έχει ο πίνακας sales.Customers |
| @numofSuppliers	| int	| 500	 | Ορίζει τον αριθμό των εγγραφών που θα έχει ο πίνακας products.Suppliers |
| @numofEmployees	| int	| 500	 | Ορίζει τον αριθμό των εγγραφών που θα έχει ο πίνακας hr.Employees |
| @numofProducts	| int	| 2000 | Ορίζει τον αριθμό των εγγραφών που θα έχει ο πίνακας products.Products |
| @numofShippers	| int	| 200	 | Ορίζει τον αριθμό των εγγραφών που θα έχει ο πίνακας sales.Shippers |
| @numofOrders	  | int	| 100000 | Ορίζει τον αριθμό των εγγραφών που θα έχει ο πίνακας sales.OrdersHeader |
| @maxItemsInOrder | int |	5	 | Ορίζει τον μέγιστο αριθμό των εγγραφών που θα έχει κάθε Order στο πίνακας sales.OrderItems |
| @calendarstartdate | date |	null | Ορίζει τον ημερομηνία από την οποία θα ξεκινάει ο πίνακας ημερολογίου bi.DimCalendar. Αν δεν περάσουμε τιμη τότε η αρχική ημερομηνία είναι πέντε χρόνια από την τρέχουσα ημερομηνία |
| @calendarnumberofyears | int | null |	Ορίζει το πόσα χρόνια θα περιέχει ο πίνακας ημερολογίου. Αν δεν περάσουμε τιμή είναι δέκα χρόνια |

Μπορείτε να αλλάξετε την οποιαδήποτε παράμετρο και να φτιάξετε το μέγεθος που θέλετε.
