﻿USE [HellasGateV2]
GO

set nocount on;
go

drop table if exists #lastnames;
go

create table #lastnames (lastname nvarchar(100), gender nchar(1));
go

insert into #lastnames values	
	(N'Αποστολάκης',N'M'),(N'Απέργης',N'M'),(N'Αλεξόπουλος',N'M'),(N'Αγγελίδης',N'M'),(N'Αντωνιάδης',N'M'),(N'Αδαμόπουλος',N'M'),
	(N'Αλαφούζος',N'M'),(N'Αλιβιζάτος',N'M'),(N'Ανδρεάδης',N'M'),(N'Αθανασούλας',N'M'),(N'Αργυράκος',N'M'),(N'Αθανασιάδης',N'M'),
	(N'Αναστασιάδης',N'M'),(N'Αργυράκης',N'M'),(N'Αρμένης',N'M'),(N'Αντωνόπουλος',N'M'),(N'Ανδρουλάκης',N'M'),(N'Αγγελίδη',N'F'),
	(N'Αλιβιζάτου',N'F'),(N'Αναστασιάδη',N'F'),(N'Ανδρεάδη',N'F'),(N'Αδαμοπούλου',N'F'),(N'Αντωνιάδη',N'F'),(N'Αντωνοπούλου',N'F'),
	(N'Απέργη',N'F'),(N'Αργυράκου',N'F'),(N'Αθανασιάδη',N'F'),(N'Αθανασούλα',N'F'),(N'Αλαφούζου',N'F'),(N'Αλεξίου',N'F'),
	(N'Αναστασίου',N'F'),(N'Ανδρέου',N'F'),(N'Ανδρουλάκη',N'F'),(N'Αποστολάκη',N'F'),(N'Αρμένη',N'F'),(N'Αλεξοπούλου',N'F'),
	(N'Αραχωβίτη',N'F'),(N'Αργυράκη',N'F'),(N'Αραχωβίτης',N'M');
go

insert into #lastnames values	
	(N'Βασιλόπουλος',N'M'),(N'Βιτάλης',N'M'),(N'Βαμβακά',N'F'),(N'Βασιλοπούλου',N'F'),(N'Βέργα',N'F'),(N'Βλαβιανού',N'F'),
	(N'Βλάσση',N'F'),(N'Βούλγαρη',N'F'),(N'Βούρου',N'F'),(N'Βιτάλη',N'F'),(N'Βαρώτσου',N'F'),(N'Βογιατζή',N'F'),(N'Βουτσινά',N'F'),
	(N'Βογιατζής',N'M'),(N'Βλαβιανός',N'M'),(N'Βλάσσης',N'M'),(N'Βαμβακάς',N'M'),(N'Βούλγαρης',N'M'),(N'Βούρος',N'M'),
	(N'Βαρώτσος',N'M'),(N'Βουτσινάς',N'M'),(N'Βέργας',N'M');
go

insert into #lastnames values	
	(N'Γραμματικόπουλος',N'M'),(N'Γιαννουκάκης',N'M'),(N'Γούσιος',N'M'),(N'Γονατάς',N'M'),(N'Γιαννόπουλος',N'M'),
	(N'Γεννηματάς',N'M'),(N'Γεωργιάδης',N'M'),(N'Γαζής',N'M'),(N'Γιαλαμάς',N'M'),(N'Γιωτόπουλος',N'M'),(N'Γεωργαντάς',N'M'),
	(N'Γαλάνης',N'M'),(N'Γιαννοπούλου',N'F'),(N'Γεννηματά',N'F'),(N'Γεωργίου',N'F'),(N'Γκιουλέκα',N'F'),(N'Γαζή',N'F'),
	(N'Γαλάνη',N'F'),(N'Γερμανό',N'F'),(N'Γεωργαντά',N'F'),(N'Γεωργιάδη',N'F'),(N'Γιωτοπούλου',N'F'),(N'Γούσιου',N'F'),
	(N'Γραμματικοπούλου',N'F'),(N'Γιαλαμά',N'F'),(N'Γιαννουκάκη',N'F'),(N'Γονατά',N'F'),(N'Γρηγορίου',N'F'),(N'Γκιουλέκας',N'M'),
	(N'Γερμανός',N'M');
go

insert into #lastnames values	
	(N'Δεσποτόπουλος',N'M'),(N'Δουρέντης',N'M'),(N'Δενδρινού',N'F'),(N'Δεσποτοπούλου',N'F'),(N'Δημητροπούλου',N'F'),
	(N'Διαμαντίδη',N'F'),(N'Δασκαλάκη',N'F'),(N'Δελή',N'F'),(N'Διαμαντοπούλου',N'F'),(N'Δημαρά',N'F'),(N'Δέδε',N'F'),
	(N'Διδασκάλου',N'F'),(N'Δουρέντη',N'F'),(N'Δασκαλάκης',N'M'),(N'Δημαράς',N'M'),(N'Δέδες',N'M'),(N'Δημητρόπουλος',N'M'),
	(N'Διαμαντόπουλος',N'M'),(N'Διαμαντίδης',N'M'),(N'Δελής',N'M'),(N'Δενδρινός',N'M');
go

insert into #lastnames values	
	(N'Ευταξίας',N'M'),(N'Ευγενίδης',N'M'),(N'Εξαρχόπουλος',N'M'),(N'Ευθυμιάδης',N'M'),(N'Εμμανουηλίδης',N'M'),
	(N'Ελευθερόπουλος',N'M'),(N'Εγκολφόπουλος',N'M'),(N'Ευθυμιάδη',N'F'),(N'Ελευθεριάδη',N'F'),(N'Εμμανουηλίδη',N'F'),
	(N'Εξαρχοπούλου',N'F'),(N'Ευγενίδη',N'F'),(N'Ελευθερίου',N'F'),(N'Ευταξία',N'F'),(N'Εγκολφοπούλου',N'F'),
	(N'Ελευθεροπουλου',N'F'),(N'Ελευθεριάδης',N'M');
go

insert into #lastnames values	
	(N'Ζαφειριάδη',N'F'),(N'Ζολώτα',N'F'),(N'Ζέρβα',N'F'),(N'Ζολώτας',N'M'),(N'Ζαφειριάδης',N'M'),(N'Ζέρβας',N'M');
go

insert into #lastnames values	
	(N'Θεοδοσιάδης',N'M'),(N'Θεοφιλόπουλος',N'M'),(N'Θεοδοσιάδη',N'F'),(N'Θεοδοσίου',N'F'),(N'Θάνου',N'F'),
	(N'Θεοφιλοπούλου',N'F'),(N'Θάνος',N'M');
go

insert into #lastnames values	
	(N'Ιακωβίδης',N'M'),(N'Ιακωβίδη',N'F'),(N'Ιωαννίδη',N'F'),(N'Ιωαννίδης',N'M');
go

insert into #lastnames values	
	(N'Κολιάτσος',N'M'),(N'Καλογεράς',N'M'),(N'Κοφινάς',N'M'),(N'Κοσμόπουλος',N'M'),(N'Καλλιγάς',N'M'),(N'Καμπούρης',N'M'),
	(N'Καρτάλης',N'M'),(N'Καρατζαφέρης',N'M'),(N'Καραβίας',N'M'),(N'Καβαλούρης',N'M'),(N'Κουταλιανός',N'M'),
	(N'Καντζιλιέρης',N'M'),(N'Κατράκης',N'M'),(N'Καλλιμανόπουλος',N'M'),(N'Καρανικόλας',N'M'),(N'Κορνάρος',N'M'),
	(N'Κοκκινάκης',N'M'),(N'Κουράκης',N'M'),(N'Κορομηλάς',N'M'),(N'Καλλιγά',N'F'),(N'Κολιάτσου',N'F'),(N'Κονδύλη',N'F'),
	(N'Κουταλιανού',N'F'),(N'Κοφινά',N'F'),(N'Καλλιμανοπούλου',N'F'),(N'Καλογήρου',N'F'),(N'Καρανικόλα',N'F'),
	(N'Κατράκη',N'F'),(N'Κοκκινάκη',N'F'),(N'Κοσμοπούλου',N'F'),(N'Καβαλούρη',N'F'),(N'Καλογερά',N'F'),(N'Καλύβα',N'F'),
	(N'Καντζιλιέρη',N'F'),(N'Κεδίκογλου',N'F'),(N'Κεχαγιά',N'F'),(N'Κόλλια',N'F'),(N'Κοντολέων',N'F'),(N'Κορνάρου',N'F'),
	(N'Κωνσταντοπούλου',N'F'),(N'Καμπούρη',N'F'),(N'Καραβία',N'F'),(N'Καρατζαφέρη',N'F'),(N'Καρτάλη',N'F'),(N'Κορομηλά',N'F'),
	(N'Κορωναίου',N'F'),(N'Κουράκη',N'F'),(N'Κυπραίου',N'F'),(N'Καλύβας',N'M'),(N'Κονδύλης',N'M'),(N'Κεχαγιάς',N'M'),
	(N'Κόλλιας',N'M'),(N'Κορωναίος',N'M'),(N'Κωνσταντόπουλος',N'M'),(N'Κυπραίος',N'M');
go

insert into #lastnames values	
	(N'Λαμπρόπουλος',N'M'),(N'Λαγός',N'M'),(N'Λαγουδάκης',N'M'),(N'Λαμπάκη',N'F'),(N'Λάμπρου',N'F'),(N'Λοβέρδου',N'F'),
	(N'Λοΐζου',N'F'),(N'Λαγού',N'F'),(N'Λαγουδάκη',N'F'),(N'Λαμέρα',N'F'),(N'Λαμπρίδη',N'F'),(N'Λάζαρη',N'F'),
	(N'Λαμπροπούλου',N'F'),(N'Λεκατσά',N'F'),(N'Λούλη',N'F'),(N'Λεκατσάς',N'M'),(N'Λάζαρης',N'M'),(N'Λαμέρας',N'M'),
	(N'Λαμπρίδης',N'M'),(N'Λοΐζος',N'M'),(N'Λοβέρδος',N'M'),(N'Λαμπάκης',N'M'),(N'Λούλης',N'M');
go

insert into #lastnames values	
	(N'Μαγγίνας',N'M'),(N'Μπέζος',N'M'),(N'Μυλωνάς',N'M'),(N'Μακρής',N'M'),(N'Μπαστιάς',N'M'),
	(N'Μεταξάς',N'M'),(N'Μοσχίδης',N'M'),(N'Μαρής',N'M'),(N'Μάμος',N'M'),(N'Μώραλης',N'M'),
	(N'Μαρκόπουλος',N'M'),(N'Μουστάκας',N'M'),(N'Μπακογιάννης',N'M'),(N'Μπλέτσας',N'M'),(N'Μουσούρης',N'M'),
	(N'Μαραγκός',N'M'),(N'Μοσχόπουλος',N'M'),(N'Μπαστιά',N'F'),(N'Μπέζου',N'F'),(N'Μπλέτσα',N'F'),
	(N'Μώραλη',N'F'),(N'Μακρή',N'F'),(N'Μαρή',N'F'),(N'Μαρινάκη',N'F'),(N'Μεταξά',N'F'),(N'Μητροπούλου',N'F'),
	(N'Μοσχοπούλου',N'F'),(N'Μουστάκα',N'F'),(N'Μπενιζέλου',N'F'),(N'Μπότσαρη',N'F'),(N'Μυλωνά',N'F'),(N'Μαγγίνα',N'F'),
	(N'Μάμου',N'F'),(N'Μανιάκη',N'F'),(N'Μαραγκού',N'F'),(N'Μαρκοπούλου',N'F'),(N'Μοσχίδη',N'F'),(N'Μουσούρη',N'F'),
	(N'Μπακογιάννη',N'F'),(N'Μπότσαρης',N'M'),(N'Μητρόπουλος',N'M'),(N'Μανιάκης',N'M'),(N'Μαρινάκης',N'M');
go

insert into #lastnames values	
	(N'Ναστού',N'F'),(N'Νάστος',N'M');
go

insert into #lastnames values	
	(N'Ξανθόπουλος',N'M'),(N'Ξανθοπούλου',N'F');
go

insert into #lastnames values	
	(N'Οικονόμου',N'F'),(N'Ουζουνίδη',N'F'),(N'Ουζουνίδης',N'M');
go

insert into #lastnames values	
	(N'Πάριος',N'M'),(N'Παναγούλη',N'F'),(N'Παπαχρήστου',N'F'),(N'Πάριου',N'F'),(N'Πετράκο',N'F'),(N'Πουλοπούλου',N'F'),
	(N'Παπανικολάου',N'F'),(N'Πασαλίδη',N'F'),(N'Παπάζογλου',N'F'),(N'Παπαντωνίου',N'F'),(N'Παπαστεφάνου',N'F'),
	(N'Παπαφιλίππου',N'F'),(N'Πέτσα',N'F'),(N'Πολίτη',N'F'),(N'Πρωτονοτάριου',N'F'),(N'Πάνου',N'F'),(N'Πανταζή',N'F'),
	(N'Παπακώστα',N'F'),(N'Παρασκευαΐδη',N'F'),(N'Παυλοπούλου',N'F'),(N'Πυλαρινού',N'F'),(N'Πουλόπουλος',N'M'),
	(N'Παναγούλης',N'M'),(N'Πυλαρινός',N'M'),(N'Παπαχρήστος',N'M'),(N'Πετράκος',N'M'),(N'Πέτσας',N'M'),(N'Πανταζής',N'M'),
	(N'Πρωτονοτάριος',N'M'),(N'Πολίτης',N'M'),(N'Παρασκευαΐδης',N'M'),(N'Παπακώστας',N'M'),(N'Παυλόπουλος',N'M'),
	(N'Πασαλίδης',N'M');
go

insert into #lastnames values	
	(N'Ράγκος',N'M'),(N'Ραγκαβής',N'M'),(N'Ρηγόπουλος',N'M'),(N'Ράγκου',N'F'),(N'Ρηγοπούλου',N'F'),(N'Ρόκα',N'F'),
	(N'Ραγκαβή',N'F'),(N'Ράμφου',N'F'),(N'Ράμφος',N'M'),(N'Ρόκας',N'M');
go

insert into #lastnames values	
	(N'Σταθόπουλος',N'M'),(N'Σαμαράς',N'M'),(N'Στεφανοπούλου',N'F'),(N'Σαμαρά',N'F'),(N'Σπηλιωτοπούλου',N'F'),
	(N'Σταθοπούλου',N'F'),(N'Στεφανή',N'F'),(N'Σημηριώτη',N'F'),(N'Σκλάβου',N'F'),(N'Σκυλακάκη',N'F'),(N'Σπυροπούλου',N'F'),
	(N'Σερπετζόγλου',N'F'),(N'Σκαρβέλη',N'F'),(N'Σκλαβούνου',N'F'),(N'Σπανού',N'F'),(N'Σταύρου',N'F'),(N'Σπανός',N'M'),
	(N'Στεφανής',N'M'),(N'Σκυλακάκης',N'M'),(N'Σκλαβούνος',N'M'),(N'Σπυρόπουλος',N'M'),(N'Σκαρβέλης',N'M'),
	(N'Σπηλιωτόπουλος',N'M'),(N'Στεφανόπουλος',N'M'),(N'Σημηριώτης',N'M'),(N'Σκλάβος',N'M');
go

insert into #lastnames values	
	(N'Τούντας',N'M'),(N'Τσιώλης',N'M'),(N'Τσόκος',N'M'),(N'Τσουκαλάς',N'M'),(N'Τρικούπης',N'M'),(N'Τοκατλίδης',N'M'),
	(N'Τσακίρης',N'M'),(N'Τριανταφυλλόπουλος',N'M'),(N'Τριανταφυλλοπούλου',N'F'),(N'Τσιώλη',N'F'),(N'Τσόκου',N'F'),
	(N'Τοκατλίδη',N'F'),(N'Τρικούπη',N'F'),(N'Τσουκαλά',N'F'),(N'Τούντα',N'F'),(N'Τσακίρη',N'F');
go

insert into #lastnames values	
	(N'Φανουράκη',N'F'),(N'Φατμελή',N'F'),(N'Φλέσσας',N'M'),(N'Φλέσσα',N'F'),(N'Φωτοπούλου',N'F'),(N'Φατμελής',N'M'),
	(N'Φωτόπουλος',N'M'),(N'Φανουράκης',N'M');
go

insert into #lastnames values	
	(N'Χρηστάκης',N'M'),(N'Χατζηπαυλής',N'M'),(N'Χαριτωνίδη',N'F'),(N'Χατζηπαυλή',N'F'),(N'Χρηστάκη',N'F'),(N'Χατζηιωάννου',N'F'),
	(N'Χατζηνικολάου',N'F'),(N'Χαριτωνίδης',N'M');
go

insert into #lastnames values	
	(N'Ψωμιάδη',N'F'),(N'Ψωμιάδης',N'M');
go

drop table if exists #firstnames;
go

create table #firstnames (firstname nvarchar(100), gender nchar(1));
go

insert into #firstnames values	
	(N'Αριστοτέλης',N'M'),(N'Αθανάσιος',N'M'),(N'Αγησίλαος',N'M'),(N'Αιμίλιος',N'M'),(N'Αριστομένης',N'M'),(N'Ανέστης',N'M'),
	(N'Αλέξανδρος',N'M'),(N'Αλέξιος',N'M'),(N'Αβραάμ',N'M'),(N'Αχιλλέας',N'M'),(N'Απόστολος',N'M'),(N'Αντώνιος',N'M'),
	(N'Ανάργυρος',N'M'),(N'Αναστάσιος',N'M'),(N'Αρτέμιος',N'M'),(N'Ασημάκης',N'M'),(N'Αριστείδης',N'M'),(N'Αγγελική',N'F'),
	(N'Αθανασία',N'F'),(N'Αιμίλια',N'F'),(N'Αλίκη',N'F'),(N'Αναστασία',N'F'),(N'Αργυρώ',N'F'),(N'Αρτεμισία',N'F'),
	(N'Ανδρέας',N'M'),(N'Αστέριος',N'M'),(N'Αδαμάντιος',N'M');
go

insert into #firstnames values	
	(N'Βίκτωρ',N'M'),(N'Βλαδίμηρος',N'M'),(N'Βλάσσιος',N'M'),(N'Βάιος',N'M'),(N'Βανέσα',N'F'),(N'Βαρβάρα',N'F'),
	(N'Βικτωρια',N'F'),(N'Βύρων',N'M'),(N'Βασίλης',N'M');
go

insert into #firstnames values	
	(N'Γαβριήλ',N'M'),(N'Γεώργιος',N'M'),(N'Γεωργία',N'F'),(N'Γεράσιμος',N'M'),(N'Γρηγόριος',N'M');
go

insert into #firstnames values	
	(N'Δαμιανός',N'M'),(N'Δημήτριος',N'M'),(N'Διονύσιος',N'M'),(N'Δηλία',N'F'),(N'Δήμητρα',N'F'),(N'Διονυσία',N'F'),
	(N'Δήμος',N'M'),(N'Δημοσθένης',N'M');
go

insert into #firstnames values	
	(N'Επαμεινώνδας',N'M'),(N'Ευριπίδης',N'M'),(N'Ελευθέριος',N'M'),(N'Ευάγγελος',N'M'),(N'Ειρήνη',N'F'),(N'Ελένη',N'F'),
	(N'Εμμανουέλα',N'F'),(N'Ευαγγελία',N'F'),(N'Ευθύμια',N'F'),(N'Ευσταθία',N'F'),(N'Ευθύμιος',N'M'),(N'Εμμανουήλ',N'M'),
	(N'Ευστάθιος',N'M'),(N'Ευστράτιος',N'M');
go

insert into #firstnames values	
	(N'Ζαχαρίας',N'M'),(N'Ζουμπουλιά',N'F'),(N'Ζήσης',N'M'),(N'Ζαφείριος',N'M');
go

insert into #firstnames values	
	(N'Ηλίας',N'M'),(N'Ηλέκτρα',N'F'),(N'Ηρώ',N'F'),(N'Ηρακλής',N'M');
go

insert into #firstnames values	
	(N'Θαλής',N'M'),(N'Θεοφάνης',N'M'),(N'Θεοδώρα',N'F'),(N'Θωμαής',N'F'),(N'Θεόδωρος',N'M'),(N'Θεοδόσιος',N'M'),
	(N'Θεόφιλος',N'M'),(N'Θωμάς',N'M'),(N'Θεμιστοκλής',N'M');
go

insert into #firstnames values	
	(N'Ιωάννης',N'M'),(N'Ιωσήφ',N'M'),(N'Ιάκωβος',N'M'),(N'Ισαάκ',N'M'),(N'Ιπποκράτης',N'M'),(N'Ισίδωρος',N'M'),(N'Ιορδάνης',N'M');
go

insert into #firstnames values	
	(N'Κλέαρχος',N'M'),(N'Κίμων',N'M'),(N'Κοσμάς',N'M'),(N'Κωνσταντίνος',N'M'),(N'Καλυψώ',N'F'),(N'Καρολίνα',N'F'),
	(N'Κασσάνδρα',N'F'),(N'Κατερίνα',N'F'),(N'Κίρκη',N'F'),(N'Κλεάνθης',N'M'),(N'Κυριάκος',N'M');
go

insert into #firstnames values	
	(N'Λήδα',N'F'),(N'Λουκία',N'F'),(N'Λυδία',N'F'),(N'Λεωνίδας',N'M'),(N'Λουκάς',N'M'),(N'Λάμπρος',N'M'),(N'Λυκούργος',N'M'),
	(N'Λάζαρος',N'M');
go

insert into #firstnames values	
	(N'Μενέλαος',N'M'),(N'Μάριος',N'M'),(N'Ματθαίος',N'M'),(N'Μιλτιάδης',N'M'),(N'Μιχαήλ',N'M'),(N'Μάγια',N'F'),
	(N'Μαργαρίτα',N'F'),(N'Μαρία',N'F'),(N'Μαρίνα',N'F'),(N'Μαρκησία',N'F'),(N'Μάρκος',N'M'),(N'Μελέτιος',N'M'),
	(N'Μαρίνος',N'M'),(N'Μηνάς',N'M');
go

insert into #firstnames values	
	(N'Νικόλαος',N'M'),(N'Νέστωρ',N'M'),(N'Νικηφόρος',N'M'),(N'Ναπολέων',N'M'),(N'Νεκτάριος',N'M'),(N'Ναυσικά',N'F'),
	(N'Νεκταρία',N'F'),(N'Νικήτας',N'M'),(N'Νεοκλής',N'M');
go

insert into #firstnames values	
	(N'Ξενοφών',N'M');
go

insert into #firstnames values	
	(N'Ορέστης',N'M'),(N'Οδυσσέας',N'M'),(N'Ορφέας',N'M');
go

insert into #firstnames values	
	(N'Πολύκαρπος',N'M'),(N'Πολυχρόνης',N'M'),(N'Πρόδρομος',N'M'),(N'Πέτρος',N'M'),(N'Πλάτων',N'M'),(N'Πάρις',N'M'),
	(N'Πολυζώης',N'M'),(N'Προκόπιος',N'M'),(N'Παρασκευάς',N'M'),(N'Παύλος',N'M'),(N'Πασχάλης',N'M'),(N'Παναγιώτης',N'M'),
	(N'Παντελής',N'M'),(N'Περικλής',N'M'),(N'Πλούταρχος',N'M');
go

insert into #firstnames values	
	(N'Ρήγας',N'M'),(N'Ρεγγίνα',N'F');
go

insert into #firstnames values	
	(N'Σαμάνθα',N'F'),(N'Σαμπρίνα',N'F'),(N'Σιλβάνα',N'F'),(N'Σοφία',N'F'),(N'Σπυριδούλα',N'F'),(N'Σταματίνα',N'F'),
	(N'Σωτηρία',N'F'),(N'Σάββας',N'M'),(N'Στέργιος',N'M'),(N'Σεραφείμ',N'M'),(N'Στέφανος',N'M'),(N'Στυλιανός',N'M'),
	(N'Σωτήριος',N'M'),(N'Σπυρίδων',N'M'),(N'Σπήλιος',N'M'),(N'Σωκράτης',N'M'),(N'Σταύρος',N'M'),(N'Σταμάτης',N'M'),
	(N'Σοφοκλής',N'M'),(N'Σόλων',N'M'),(N'Σαράντος',N'M'),(N'Σέργιος',N'M');
go

insert into #firstnames values	
	(N'Τιμόθεος',N'M'),(N'Τρύφων',N'M'),(N'Τριαντάφυλλος',N'M'),(N'Τηλέμαχος',N'M'),(N'Τσαμπίκα',N'F');
go

insert into #firstnames values	(N'Υακίνθη',N'F');
go

insert into #firstnames values	
	(N'Φαίδρα',N'F'),(N'Φοίβη',N'F'),(N'Φίλιππος',N'M'),(N'Φώτιος',N'M'),(N'Φωκίων',N'M'),(N'Φανούριος',N'M'),(N'Φαίδων',N'M'),
	(N'Φραγκίσκος',N'M'),(N'Φοίβος',N'M');
go
insert into #firstnames values	
	(N'Χριστόφορος',N'M'),(N'Χριστόδουλος',N'M'),(N'Χρύσανθος',N'M'),(N'Χαράλαμπος',N'M'),(N'Χρυσόστομος',N'M'),(N'Χρήστος',N'M'),
	(N'Χαρίλαος',N'M'),(N'Χάιδω',N'F'),(N'Χαραλαμπία',N'F');
go

set nocount off;

insert into dfi.GreekNames([lastname], [firstname], [gender])
select lastname, firstname, #firstnames.gender from #lastnames
cross join #firstnames
where #lastnames.gender = #firstnames.gender;
go