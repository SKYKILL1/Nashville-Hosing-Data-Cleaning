select * from [Nashville Housing Data for Data Cleaning];

--Populating propertyAddress
Select * 
from [Nashville Housing Data for Data Cleaning]
--where PropertyAddress is NULL
order by ParcelID


Select a.ParcelID,a.PropertyAddress , b.ParcelID , b.PropertyAddress  
from [Nashville Housing Data for Data Cleaning] a
join [Nashville Housing Data for Data Cleaning] b
on a.UniqueID <> b.UniqueID AND a.ParcelID = b.ParcelID
where a.PropertyAddress is NULL

Update a
set PropertyAddress = ISNULL(A.propertyAddress , b.PropertyAddress)
from [Nashville Housing Data for Data Cleaning] a
join [Nashville Housing Data for Data Cleaning] b
on a.UniqueID <> b.UniqueID AND a.ParcelID = b.ParcelID
where a.PropertyAddress is NULL





Select PropertyAddress , SUBSTRING(PropertyAddress ,1, CHARINDEX(',',PropertyAddress,1) - 1 )
from [Nashville Housing Data for Data Cleaning];

Select PropertyAddress , SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress,1) +1 , LEN(PropertyAddress))
from [Nashville Housing Data for Data Cleaning];



Alter Table [Nashville Housing Data For Data Cleaning]
Add PropHomeAddress Varchar(50)

Update [Nashville Housing Data for Data Cleaning]
Set PropHomeAddress = SUBSTRING(PropertyAddress ,1, CHARINDEX(',',PropertyAddress,1) - 1 );

Alter Table [Nashville Housing Data For Data Cleaning]
Add PropHomeCity Varchar(50)

Update [Nashville Housing Data for Data Cleaning]
Set PropHomeCity = SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress,1) + 1 , LEN(PropertyAddress))

--Populating OwnerAddress

select OwnerAddress from [Nashville Housing Data for Data Cleaning];

Select a.ParcelID,a.OwnerAddress , b.ParcelID , b.OwnerAddress
from [Nashville Housing Data for Data Cleaning] a
join [Nashville Housing Data for Data Cleaning] b
on a.UniqueID <> b.UniqueID AND a.ParcelID = b.ParcelID
where a.PropertyAddress is NULL


select OwnerAddress,PARSENAME(Replace(OwnerAddress,',' , '.'),1)
from [Nashville Housing Data for Data Cleaning];

select OwnerAddress,PARSENAME(Replace(OwnerAddress,',' , '.'),2)
from [Nashville Housing Data for Data Cleaning];

select OwnerAddress,PARSENAME(Replace(OwnerAddress,',' , '.'),3)
from [Nashville Housing Data for Data Cleaning];



Alter Table [Nashville Housing Data For Data Cleaning]
Add OwnerHomeAddress Varchar(50)


Alter Table [Nashville Housing Data For Data Cleaning]
Add OwnerHomeState Varchar(50)


Alter Table [Nashville Housing Data For Data Cleaning]
Add OwnerHomeCity Varchar(50)


Update [Nashville Housing Data for Data Cleaning]
Set OwnerHomeAddress = PARSENAME(Replace(OwnerAddress,',' , '.'),3)

Update [Nashville Housing Data for Data Cleaning]
Set OwnerHomeState = PARSENAME(Replace(OwnerAddress,',' , '.'),1)

Update [Nashville Housing Data for Data Cleaning]
Set OwnerHomeCity = PARSENAME(Replace(OwnerAddress,',' , '.'),2)


--duplicates removal

select * from [Nashville Housing Data for Data Cleaning];

with duplicatecount as(
select *,
	Row_number() Over (
	Partition by parcelID,
	propertyaddress,
	saleprice,
	legalReference,saledate
	order by uniqueid) as rownum
from [Nashville Housing Data for Data Cleaning]
--order by parcelid
)
select * from duplicatecount
where rownum>1
order by uniqueid


with duplicatecount as(
select *,
	Row_number() Over (
	Partition by parcelID,
	propertyaddress,
	saleprice,
	legalReference,saledate
	order by uniqueid) as rownum
from [Nashville Housing Data for Data Cleaning]
--order by parcelid
)
delete from duplicatecount 
where rownum>1

-- soldasvacant update

select distinct SoldAsVacant from [Nashville Housing Data for Data Cleaning]

alter table [Nashville Housing Data for Data Cleaning]
alter column soldasvacant varchar(5)

update [Nashville Housing Data for Data Cleaning]
set SoldAsVacant = case when soldasvacant = '0' then 'No'
		 else 'Yes'
		 end;


--delete unused columns

select * from [Nashville Housing Data for Data Cleaning];

alter table [Nashville Housing Data for Data Cleaning]
drop column owneraddress,propertyaddress , taxdistrict, saledate;

select * from [Nashville Housing Data for Data Cleaning]
order by uniqueid;

