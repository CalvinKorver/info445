# Data warehousing vs data mart

* DW -> Enterprising wide
* DM -> Division / department wide

**Data marts**:

* Cheaper
* Quicker
* Less Complex
* Less political (there is only a single stakeholder)

Remember, to do this properly, we need to use the star data table format

* Main part of this is the FACT table
* Surrounded by other tables, eg (Time, Employee, Machine, Customer)
* The FACT table has a composite primary key made up of foreign keys added

### How do you update a star table?

1. Over write the existing data
    - Lose history
2. Create a new row
3. Create a new column