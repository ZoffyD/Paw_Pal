-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2025 at 02:00 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 1, 'jorge', 'Dog', 'Help/Rescue', 'adorable and cute', 'pet_1_1.png, pet_1_2.png', '6.4640033', '100.5007833', '2025-12-05 15:00:21'),
(2, 1, 'meow', 'Cat', 'Donation Request', 'naughty but sleepy', 'pet_2_1.png', '6.4640033', '100.5007833', '2025-12-05 15:33:40'),
(3, 1, 'zaizai', 'Rabbit', 'Adoption', 'smelly but cute ', 'pet_3_1.png', '6.4640033', '100.5007833', '2025-12-05 15:34:17'),
(4, 1, 'bubu', 'Other', 'Adoption', 'youyouyooyo', 'pet_4_1.png', '6.4640033', '100.5007833', '2025-12-05 16:16:24'),
(5, 1, 'jiji', 'Cat', 'Donation Request', 'lololololol', 'pet_5_1.png', '6.4640033', '100.5007833', '2025-12-05 18:07:59'),
(6, 1, 'LOL', 'Dog', 'Adoption', 'cute and clusmy', 'pet_6_1.png, pet_6_2.png', '6.4640033', '100.5007833', '2025-12-05 19:22:15'),
(7, 2, 'pawpaw', 'Cat', 'Donation Request', 'please help ! i am sick I need money to cure', 'pet_7_1.png', '6.4640033', '100.5007833', '2025-12-05 20:13:07');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`) VALUES
(1, 'jun', 'jun@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', '2025-11-27 10:52:34'),
(2, 'ali', 'ali@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', '2025-12-05 19:26:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
