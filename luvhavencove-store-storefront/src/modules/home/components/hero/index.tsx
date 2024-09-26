import { Github } from "@medusajs/icons"
import { Button, Heading } from "@medusajs/ui"
import Image from 'next/image'
import banner from '../../../../../public/images/banner.jpg';

const Hero = () => {
  return (
    <div className="flex flex-col items-center border-b border-ui-border-base relative py-12" style={{backgroundColor: "#f3f1f2"}}>
      <Image
          className="w-[70vw] sm:w-[30vw]"
          src={banner}
          alt='banner.webp'
          width={'500'}
          height={'500'}
        ></Image>
    </div>
  )
}

export default Hero
