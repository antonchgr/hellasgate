# The HellasGate sample database

## Overview

Όλα αυτά τα χρόνια που ασχολούμαι με το SQL Server έχω χρησιμοποιήσει πολλές databases που χαρακτηρίζονται σαν sample database τόσο στα μαθήματα που κάνω όσο και στις παρουσιάσεις μου.

Έχοντας ξεκινήσει από την Pubs στις εκδόσεις τους SQL Server 6,6.5,7, την Northwind στις 7, 2000 και μετά τις AdventureWorks, Contoso, WorldWideImporters έκανα ωραιότατα την δουλειά μου.

Παρόλα αυτά όμως πάντα ήθελα να φτιάξω μια δικιά μου sample database που να καλύπτει τις ανάγκες μου που κάποιες από αυτές ήταν / είναι:

- Να έχουν ελληνικό περιεχόμενο για μπορώ να δείχνω χαρακτηριστικά όπως full-text search.
- Να είναι ready for analytics.
- Να αποτελεί την βάση πάνω στην οποία θα μπορώ να προσθέτω και να αφαιρώ τα εκάστοτε features που υπάρχουν ή θα εμφανιστούν στο SQL Server.
- Να μπορώ να τη μεγαλώνω σε χώρο και αριθμό εγγραφών με εύκολο τρόπο.

## Τhe HellasGate database
Όπως συμβαίνει πάντα σε όλους μας αυτό το project έπαιρνε συνέχεια αναβολή μέχρι που βρήκα το χρόνο για να το υλοποιήσω.

Είμαι στην ευχάριστη θέση να σας παρουσιάσω την HellasGate sample database.

H database αυτή είναι μια βάση που περιέχει την λογική ενός retail store που είναι μια επιχειρηματική δραστηριότητα που όλοι γνωρίζουν καθώς είναι στην καθημερινότητα μας. Περιέχει παραγγελίες και τιμολόγια, πελάτες, προμηθευτές, διακινητές, προϊόντα.

H database αυτή έχει τρία data files και ένα log file. Το mdf όπως πάντα είναι στο primary filegroup και υπάρχει το secondary filegroup στο οποίο ανήκουν τα επόμενα δύο data files. Το secondary filegroup είναι το default που σημαίνει ότι όλα τα objects δημιουργούνται σε αυτό.

### The dfi schema
Υπάρχουν αρκετά schemas που εύκολα θα δείτε με μια ματιά αλλά υπάρχει και το dfi schema που είναι αυτό περιέχει όλη την δουλειά που έχω κάνει για να καλύψω τις ανάγκες που ανέφερα και παραπάνω. Σε αυτό υπάρχουν tables και stored procedures που δεν είναι ορατά με την πρώτη ματιά καθώς τα έχω κάνω hide from client tools.

Τα tables που υπάρχουν σε αυτό το schema είναι τα Cities, GreekNames, Streets που περιέχουν αυτό που λένε απλά είναι με ελληνικά.

Επίσης υπάρχουν οι stored procedures ClearData, οι GenerateΧΧΧΧ, που κάνουν αυτό που λέει το όνομα τους και η βασική που καλεί όλες τις παραπάνω η ReGenerateData.

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
