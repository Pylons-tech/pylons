import React, { useState } from 'react'
// import { useRouter } from 'next/router'
import { MainLoader } from '@molecules'

export const MainLayout = ({
  children
}: {
  children: React.ReactNode
}): JSX.Element => {
  const [loading] = useState(false)
  // const router = useRouter()

  // const token = localStorage.getItem("token");
  // useEffect(() => {
  //   if (router?.asPath.startsWith("/app") && !token) {
  //     router?.push("/");
  //   } else if (!router?.asPath.startsWith("/app") && token) {
  //     router?.push("/app");
  //   } else {
  //     setLoading(false);
  //   }
  // }, [router, token]);

  if (loading) {
    return <MainLoader />
  }
  return <>{children}</>
}
