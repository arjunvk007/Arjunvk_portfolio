/*

Cleaning Data in SQL Queries

*/

Select *
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

--Standardise the date format

Select saledate, CONVERT(Date,Saledate) 
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Set SaleDate=CONVERT(Date,Saledate)

Alter Table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Add Saledateconverted Date;

Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Set Saledateconverted = Convert(Date, Saledate)

Select SALEDATECONVERTED
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

--Populate Property Address Data

Select *
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Where PropertyAddress is null

Select a.PropertyAddress, a.ParcelID, b.PropertyAddress, b.ParcelID, ISNULL(a.propertyaddress,b.PropertyAddress)
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing a
Join SQLPortfolioProjectDataExploration.dbo.NashvilleHousing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set propertyaddress=ISNULL(a.propertyaddress,b.propertyAddress)
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing a
Join SQLPortfolioProjectDataExploration.dbo.NashvilleHousing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking Out Address into individual Coloumns (Address, City, State)

Select PropertyAddress
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
--Where PropertyAddress IS NULL

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',Propertyaddress)+1, len(Propertyaddress)) as Address
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

Alter table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Add propertysplitaddress Nvarchar(255);

Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Alter table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Add propertysplitcity Nvarchar(255);

Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Set Propertysplitcity=SUBSTRING(PropertyAddress, CHARINDEX(',',Propertyaddress)+1, len(Propertyaddress))

Select
PARSENAME(Replace(Owneraddress,',','.'),3) as address, 
Parsename(Replace(Owneraddress,',','.'),2) as City,
Parsename(Replace(owneraddress,',','.'),1) as State
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

Alter Table  SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Add ownersplitaddress Nvarchar(255);

Update  SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Set ownersplitaddress=PARSENAME(Replace(Owneraddress,',','.'),3)

	Alter table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
	Add Ownersplitcity Nvarchar (255);

	Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
	Set Ownersplitcity=PARSENAME(Replace(OwnerAddress,',','.'),2)

	Alter Table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
	Add ownersplitstate Nvarchar(255);

	Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
	Set ownersplitstate=PARSENAME(Replace(Owneraddress,',','.'),1)

Select *
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

--Change Y and N to Yes and NO in 'sold as vacant field'

Select Distinct (Soldasvacant), Count(Soldasvacant)
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Group by (Soldasvacant)
Order by 2

SELECT soldasvacant,
Case 
When Soldasvacant ='Y' then 'Yes'
When Soldasvacant ='N' then 'No'
Else SoldAsVacant
End as soldasvacantupdated
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

Update SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Set SoldAsVacant=Case 
When Soldasvacant ='Y' then 'Yes'
When Soldasvacant ='N' then 'No'
Else SoldAsVacant
End
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

--Remove Duplicates

With rownumCTE as(
Select*,
ROW_NUMBER() Over(
Partition by ParcelID, Propertyaddress, Saleprice, Saledate, LegalReference
Order by UniqueID
) row_num

From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
--order by ParcelID
)
Select * --Delete fn to delete 
From rownumCTE
Where row_num > 1
Order by propertyaddress

select *
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

--Delete Unused coloumns

select *
From SQLPortfolioProjectDataExploration.dbo.NashvilleHousing

Alter Table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Drop Column OwnerAddress 

Alter Table SQLPortfolioProjectDataExploration.dbo.NashvilleHousing
Drop Column TaxDistrict, PropertyAddress, SaleDate













