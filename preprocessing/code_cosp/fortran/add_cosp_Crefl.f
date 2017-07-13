!! declare the cloud reflectance as an additional local variable
   real, dimension(Npoints,PARASOL_NREFL) :: parasolCrefl

…

! write standard PARASOL reflectance
    CALL output_write(stlidar%parasolrefl)

! compute cloud reflectance
    do k=1,PARASOL_NREFL
     do ip=1, Npoints
      if (stlidar%cldlayer(ip,4).gt.0.01) then
        parasolCrefl(ip,k)=(stlidar%parasolrefl(ip,k) &
  &        - 0.03*(1.-stlidar%cldlayer(ip,4)))/ stlidar%cldlayer(ip,4)
       else
         parasolCrefl(ip,k)=missing_val
      endif
     enddo
    enddo
!
! compute cloud reflectance
CALL output_write(parasolCrefl)
