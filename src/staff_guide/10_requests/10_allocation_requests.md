### Allocation Requests
<a name="allocation"></a>
**If a user has an active resource request, their request will appear under the "Resource Requests" tab in the Troposphere Admin UI. Otherwise, allocation and quota increases must be handled through the Django admin UI.**

#### Granting a larger Allocation via Admin Pages
<a name="changing-allocation"></a>
Navigate to `https://<site_url>/admin/core/identitymembership` and search for the user you are changing. The results will contain a new entry for every membership that user belongs to, which is effectively an "account" on every provider the user has access to. Select the appropriate identity membership based on the provider you want to change the user's allocation or quota on.  

To change a user's allocation, select the "allocation" dropdown menu and select the new allocation to assign.

- "Threshold": the number of CPU minutes to allocate. Eg. 168 AU = 10080 threshold value
- "Delta": positive to indicate an allowance that expires at the end of the month, and a -1 value indicates a permanent allowance.

If the allocation you would like to assign is not listed, you can create it by clicking the green plus sign to the right of the dropdown.  
**Do Not** edit the existing allocation.

#### Granting a larger Quota via Admin Pages
<a name="changing quota"></a>

To change a user's quota, select the "quota" dropdown menu and select the new quota to assign.

- CPU: The total number of CPUs a user's instances can utilize. Eg. A value of 16 can equal two 8 CPU instances, four 4 CPU instances, etc.
- MEM: The total amount of RAM a user's instances can utilize in GB.
- DISK: The total amount of storage a user's volumes can utilize in GB.
- DISK #: The total number of volumes a user can have at one time.
- SUSPEND #: The total number of suspended instances a user can have at one time.

If the quota you would like to assign is not listed, you can create it by clicking the green plus sign to the right of the dropdown.  
**Do Not** edit the existing quota.

##### Example:
<a name="allocation-example"></a>
How to grant a quota or allocation from the Django Admin panel:  

![Granting Allocation/Quota via Django Admin](./media/adjust_quota_allocation_from_admin.gif)

